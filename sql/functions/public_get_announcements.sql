drop function if exists deribit.public_get_announcements;

create or replace function deribit.public_get_announcements(
	start_timestamp bigint default null,
	count bigint default null
)
returns setof deribit.public_get_announcements_response_result
language sql
as $$
    
    with request as (
        select row(
			start_timestamp,
			count
        )::deribit.public_get_announcements_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_announcements'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_announcements_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).body::text,
		(b).confirmation::boolean,
		(b).id::double precision,
		(b).important::boolean,
		(b).publication_timestamp::bigint,
		(b).title::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_announcements is 'Retrieves announcements. Default "start_timestamp" parameter value is current timestamp, "count" parameter value must be between 1 and 50, default is 5.';

