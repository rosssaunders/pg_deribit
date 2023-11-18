create or replace function deribit.private_cancel_all_by_kind_or_type(
	currency UNKNOWN - string or array of strings,
	kind deribit.private_cancel_all_by_kind_or_type_request_kind default null,
	type deribit.private_cancel_all_by_kind_or_type_request_type default null,
	detailed boolean default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_all_by_kind_or_type_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		kind,
		type,
		detailed
    )::deribit.private_cancel_all_by_kind_or_type_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_all_by_kind_or_type', _request);

    perform deribit.matching_engine_request_log_call('/private/cancel_all_by_kind_or_type');

    return (jsonb_populate_record(
        null::deribit.private_cancel_all_by_kind_or_type_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_all_by_kind_or_type is 'Cancels all orders in currency(currencies), optionally filtered by instrument kind and/or order type.';

