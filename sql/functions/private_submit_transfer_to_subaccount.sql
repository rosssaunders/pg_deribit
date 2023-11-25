drop function if exists deribit.private_submit_transfer_to_subaccount;

create or replace function deribit.private_submit_transfer_to_subaccount(
	currency deribit.private_submit_transfer_to_subaccount_request_currency,
	amount double precision,
	destination bigint
)
returns deribit.private_submit_transfer_to_subaccount_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			amount,
			destination
        )::deribit.private_submit_transfer_to_subaccount_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/submit_transfer_to_subaccount'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_submit_transfer_to_subaccount_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_submit_transfer_to_subaccount is 'Transfer funds to subaccount.';

