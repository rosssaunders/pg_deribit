drop function if exists deribit.private_get_order_state;

create or replace function deribit.private_get_order_state(
	order_id text
)
returns deribit.private_get_order_state_response_result
language sql
as $$
    
    with request as (
        select row(
			order_id
        )::deribit.private_get_order_state_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_order_state'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_order_state_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_order_state is 'Retrieve the current state of an order.';

