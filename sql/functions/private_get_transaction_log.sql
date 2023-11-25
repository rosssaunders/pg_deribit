drop function if exists deribit.private_get_transaction_log;

create or replace function deribit.private_get_transaction_log(
	currency deribit.private_get_transaction_log_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	query text default null,
	count bigint default null,
	continuation bigint default null
)
returns deribit.private_get_transaction_log_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			start_timestamp,
			end_timestamp,
			query,
			count,
			continuation
        )::deribit.private_get_transaction_log_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_transaction_log'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_transaction_log_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_transaction_log is 'Retrieve the latest user trades that have occurred for a specific instrument and within given time range.';

