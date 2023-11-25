drop function if exists deribit.private_cancel_all_by_instrument;

create or replace function deribit.private_cancel_all_by_instrument(
	instrument_name text,
	type deribit.private_cancel_all_by_instrument_request_type default null,
	detailed boolean default null,
	include_combos boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			type,
			detailed,
			include_combos
        )::deribit.private_cancel_all_by_instrument_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/cancel_all_by_instrument'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_cancel_all_by_instrument_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel_all_by_instrument is 'Cancels all orders by instrument, optionally filtered by order type.';

