drop function if exists deribit.private_get_user_trades_by_instrument_and_time;

create or replace function deribit.private_get_user_trades_by_instrument_and_time(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint,
	count bigint default null,
	sorting deribit.private_get_user_trades_by_instrument_and_time_request_sorting default null
)
returns deribit.private_get_user_trades_by_instrument_and_time_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_user_trades_by_instrument_and_time_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name,
		start_timestamp,
		end_timestamp,
		count,
		sorting
    )::deribit.private_get_user_trades_by_instrument_and_time_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_user_trades_by_instrument_and_time'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_instrument_and_time_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_user_trades_by_instrument_and_time is 'Retrieve the latest user trades that have occurred for a specific instrument and within given time range.';

