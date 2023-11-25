drop function if exists deribit.private_get_access_log;

create or replace function deribit.private_get_access_log(
	"offset" bigint default null,
	count bigint default null
)
returns setof deribit.private_get_access_log_response_result
language sql
as $$
    
    with request as (
        select row(
			"offset",
			count
        )::deribit.private_get_access_log_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_access_log'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_access_log_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).city::text,
		(b).country::text,
		(b).data::text,
		(b).id::bigint,
		(b).ip::text,
		(b).log::text,
		(b).timestamp::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_access_log is 'Lists access logs for the user';

