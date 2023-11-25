drop function if exists deribit.private_get_settlement_history_by_currency;

create or replace function deribit.private_get_settlement_history_by_currency(
	currency deribit.private_get_settlement_history_by_currency_request_currency,
	type deribit.private_get_settlement_history_by_currency_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.private_get_settlement_history_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_settlement_history_by_currency_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		type,
		count,
		continuation,
		search_start_timestamp
    )::deribit.private_get_settlement_history_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_settlement_history_by_currency'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_settlement_history_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_settlement_history_by_currency is 'Retrieves settlement, delivery and bankruptcy events that have affected your account.';

