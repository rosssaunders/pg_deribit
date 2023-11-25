drop function if exists deribit.private_cancel_all_by_currency;

create or replace function deribit.private_cancel_all_by_currency(
	currency deribit.private_cancel_all_by_currency_request_currency,
	kind deribit.private_cancel_all_by_currency_request_kind default null,
	type deribit.private_cancel_all_by_currency_request_type default null,
	detailed boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
			currency,
			kind,
			type,
			detailed
        )::deribit.private_cancel_all_by_currency_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/cancel_all_by_currency'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_cancel_all_by_currency_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel_all_by_currency is 'Cancels all orders by currency, optionally filtered by instrument kind and/or order type.';

