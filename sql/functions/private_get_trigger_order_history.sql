drop function if exists deribit.private_get_trigger_order_history;

create or replace function deribit.private_get_trigger_order_history(
	currency deribit.private_get_trigger_order_history_request_currency,
	instrument_name text default null,
	count bigint default null,
	continuation text default null
)
returns deribit.private_get_trigger_order_history_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			instrument_name,
			count,
			continuation
        )::deribit.private_get_trigger_order_history_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_trigger_order_history'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_trigger_order_history_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_trigger_order_history is 'Retrieves detailed log of the user''s trigger orders.';

