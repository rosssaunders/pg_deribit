drop function if exists deribit.private_withdraw;

create or replace function deribit.private_withdraw(
	currency deribit.private_withdraw_request_currency,
	address text,
	amount double precision,
	priority deribit.private_withdraw_request_priority default null
)
returns deribit.private_withdraw_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			address,
			amount,
			priority
        )::deribit.private_withdraw_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/withdraw'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_withdraw_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_withdraw is 'Creates a new withdrawal request';

