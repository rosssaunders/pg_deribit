drop function if exists deribit.private_cancel_all;

create or replace function deribit.private_cancel_all(
	detailed boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
			detailed
        )::deribit.private_cancel_all_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/cancel_all'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_cancel_all_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel_all is 'This method cancels all users orders and trigger orders within all currencies and instrument kinds.';

