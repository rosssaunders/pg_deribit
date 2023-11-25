drop function if exists deribit.public_get_last_trades_by_instrument_and_time;

create or replace function deribit.public_get_last_trades_by_instrument_and_time(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint,
	count bigint default null,
	sorting deribit.public_get_last_trades_by_instrument_and_time_request_sorting default null
)
returns deribit.public_get_last_trades_by_instrument_and_time_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			start_timestamp,
			end_timestamp,
			count,
			sorting
        )::deribit.public_get_last_trades_by_instrument_and_time_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_last_trades_by_instrument_and_time'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_last_trades_by_instrument_and_time_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_last_trades_by_instrument_and_time is 'Retrieve the latest trades that have occurred for a specific instrument and within given time range.';

