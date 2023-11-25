drop function if exists deribit.private_get_user_trades_by_instrument;

create or replace function deribit.private_get_user_trades_by_instrument(
	instrument_name text,
	start_seq bigint default null,
	end_seq bigint default null,
	count bigint default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	sorting deribit.private_get_user_trades_by_instrument_request_sorting default null
)
returns deribit.private_get_user_trades_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			start_seq,
			end_seq,
			count,
			start_timestamp,
			end_timestamp,
			sorting
        )::deribit.private_get_user_trades_by_instrument_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_user_trades_by_instrument'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_instrument_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_user_trades_by_instrument is 'Retrieve the latest user trades that have occurred for a specific instrument.';

