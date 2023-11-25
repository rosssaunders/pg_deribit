drop function if exists deribit.private_submit_transfer_to_user;

create or replace function deribit.private_submit_transfer_to_user(
	currency deribit.private_submit_transfer_to_user_request_currency,
	amount double precision,
	destination text
)
returns deribit.private_submit_transfer_to_user_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			amount,
			destination
        )::deribit.private_submit_transfer_to_user_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/submit_transfer_to_user'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_submit_transfer_to_user_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_submit_transfer_to_user is 'Transfer funds to another user.';

