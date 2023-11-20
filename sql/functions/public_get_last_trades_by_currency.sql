drop function if exists deribit.public_get_last_trades_by_currency;
create or replace function deribit.public_get_last_trades_by_currency(
	currency deribit.public_get_last_trades_by_currency_request_currency,
	kind deribit.public_get_last_trades_by_currency_request_kind default null,
	start_id text default null,
	end_id text default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	count bigint default null,
	sorting deribit.public_get_last_trades_by_currency_request_sorting default null
)
returns deribit.public_get_last_trades_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_last_trades_by_currency_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_last_trades_by_currency');
    
_request := row(
		currency,
		kind,
		start_id,
		end_id,
		start_timestamp,
		end_timestamp,
		count,
		sorting
    )::deribit.public_get_last_trades_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_last_trades_by_currency', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_last_trades_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_last_trades_by_currency is 'Retrieve the latest trades that have occurred for instruments in a specific currency symbol.';

