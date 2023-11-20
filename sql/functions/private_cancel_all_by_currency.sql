drop function if exists deribit.private_cancel_all_by_currency;
create or replace function deribit.private_cancel_all_by_currency(
	currency deribit.private_cancel_all_by_currency_request_currency,
	kind deribit.private_cancel_all_by_currency_request_kind default null,
	type deribit.private_cancel_all_by_currency_request_type default null,
	detailed boolean default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_all_by_currency_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/cancel_all_by_currency');
    
_request := row(
		currency,
		kind,
		type,
		detailed
    )::deribit.private_cancel_all_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_all_by_currency', _request);

    return (jsonb_populate_record(
        null::deribit.private_cancel_all_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_all_by_currency is 'Cancels all orders by currency, optionally filtered by instrument kind and/or order type.';

