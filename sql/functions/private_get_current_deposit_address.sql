drop function if exists deribit.private_get_current_deposit_address;

create or replace function deribit.private_get_current_deposit_address(
	currency deribit.private_get_current_deposit_address_request_currency
)
returns deribit.private_get_current_deposit_address_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_current_deposit_address_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency
    )::deribit.private_get_current_deposit_address_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_current_deposit_address'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_current_deposit_address_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_current_deposit_address is 'Retrieve deposit address for currency';

