drop function if exists deribit.private_get_subaccounts_details;

create or replace function deribit.private_get_subaccounts_details(
	currency deribit.private_get_subaccounts_details_request_currency,
	with_open_orders boolean default null
)
returns setof deribit.private_get_subaccounts_details_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			with_open_orders
        )::deribit.private_get_subaccounts_details_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_subaccounts_details'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_subaccounts_details_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).open_orders::deribit.private_get_subaccounts_details_response_open_order[]
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_subaccounts_details is 'Get subaccounts positions';

