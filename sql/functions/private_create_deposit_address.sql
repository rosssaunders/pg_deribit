drop function if exists deribit.private_create_deposit_address;

create or replace function deribit.private_create_deposit_address(
	currency deribit.private_create_deposit_address_request_currency
)
returns deribit.private_create_deposit_address_response_result
language sql
as $$
    
    with request as (
        select row(
			currency
        )::deribit.private_create_deposit_address_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/create_deposit_address'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_create_deposit_address_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_create_deposit_address is 'Creates deposit address in currency';

