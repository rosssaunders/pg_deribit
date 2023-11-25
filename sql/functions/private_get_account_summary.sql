drop function if exists deribit.private_get_account_summary;

create or replace function deribit.private_get_account_summary(
	currency deribit.private_get_account_summary_request_currency,
	subaccount_id bigint default null,
	extended boolean default null
)
returns deribit.private_get_account_summary_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			subaccount_id,
			extended
        )::deribit.private_get_account_summary_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_account_summary'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_account_summary_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_account_summary is 'Retrieves user account summary. To read subaccount summary use subaccount_id parameter.';

