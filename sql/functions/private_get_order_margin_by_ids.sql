drop function if exists deribit.private_get_order_margin_by_ids;

create or replace function deribit.private_get_order_margin_by_ids(
	ids UNKNOWN - array - False - False - False
)
returns setof deribit.private_get_order_margin_by_ids_response_result
language sql
as $$
    
    with request as (
        select row(
			ids
        )::deribit.private_get_order_margin_by_ids_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_order_margin_by_ids'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_order_margin_by_ids_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).initial_margin::double precision,
		(b).initial_margin_currency::text,
		(b).order_id::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_order_margin_by_ids is 'Retrieves initial margins of given orders';

