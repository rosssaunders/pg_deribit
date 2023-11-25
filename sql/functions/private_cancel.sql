drop function if exists deribit.private_cancel;

create or replace function deribit.private_cancel(
	order_id text
)
returns deribit.private_cancel_response_result
language sql
as $$
    
    with request as (
        select row(
			order_id
        )::deribit.private_cancel_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/cancel'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_cancel_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel is 'Cancel an order, specified by order id';

