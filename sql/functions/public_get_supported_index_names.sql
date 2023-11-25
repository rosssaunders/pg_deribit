drop function if exists deribit.public_get_supported_index_names;

create or replace function deribit.public_get_supported_index_names(
	type deribit.public_get_supported_index_names_request_type default null
)
returns setof text

language sql
as $$
    
    with request as (
        select row(
			type
        )::deribit.public_get_supported_index_names_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_supported_index_names'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_supported_index_names_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		a.b
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_supported_index_names is 'Retrieves the identifiers of all supported Price Indexes';

