drop function if exists deribit.public_get_last_trades_by_currency_and_time;

create or replace function deribit.public_get_last_trades_by_currency_and_time(
	currency deribit.public_get_last_trades_by_currency_and_time_request_currency,
	kind deribit.public_get_last_trades_by_currency_and_time_request_kind default null,
	start_timestamp bigint,
	end_timestamp bigint,
	count bigint default null,
	sorting deribit.public_get_last_trades_by_currency_and_time_request_sorting default null
)
returns deribit.public_get_last_trades_by_currency_and_time_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_last_trades_by_currency_and_time_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		kind,
		start_timestamp,
		end_timestamp,
		count,
		sorting
    )::deribit.public_get_last_trades_by_currency_and_time_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_last_trades_by_currency_and_time'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.public_get_last_trades_by_currency_and_time_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_last_trades_by_currency_and_time is 'Retrieve the latest trades that have occurred for instruments in a specific currency symbol and within given time range.';

