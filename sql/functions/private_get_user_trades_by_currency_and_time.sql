drop function if exists deribit.private_get_user_trades_by_currency_and_time;
create or replace function deribit.private_get_user_trades_by_currency_and_time(
	currency deribit.private_get_user_trades_by_currency_and_time_request_currency,
	kind deribit.private_get_user_trades_by_currency_and_time_request_kind default null,
	start_timestamp bigint,
	end_timestamp bigint,
	count bigint default null,
	sorting deribit.private_get_user_trades_by_currency_and_time_request_sorting default null
)
returns deribit.private_get_user_trades_by_currency_and_time_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_user_trades_by_currency_and_time_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_user_trades_by_currency_and_time');
    
_request := row(
		currency,
		kind,
		start_timestamp,
		end_timestamp,
		count,
		sorting
    )::deribit.private_get_user_trades_by_currency_and_time_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_user_trades_by_currency_and_time', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_currency_and_time_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_user_trades_by_currency_and_time is 'Retrieve the latest user trades that have occurred for instruments in a specific currency symbol and within given time range.';

