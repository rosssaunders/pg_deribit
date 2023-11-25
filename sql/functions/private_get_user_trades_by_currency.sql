drop function if exists deribit.private_get_user_trades_by_currency;

create or replace function deribit.private_get_user_trades_by_currency(
	currency deribit.private_get_user_trades_by_currency_request_currency,
	kind deribit.private_get_user_trades_by_currency_request_kind default null,
	start_id text default null,
	end_id text default null,
	count bigint default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	sorting deribit.private_get_user_trades_by_currency_request_sorting default null,
	subaccount_id bigint default null
)
returns deribit.private_get_user_trades_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_user_trades_by_currency_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		kind,
		start_id,
		end_id,
		count,
		start_timestamp,
		end_timestamp,
		sorting,
		subaccount_id
    )::deribit.private_get_user_trades_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_user_trades_by_currency'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_user_trades_by_currency is 'Retrieve the latest user trades that have occurred for instruments in a specific currency symbol. To read subaccount trades, use subaccount_id parameter.';

