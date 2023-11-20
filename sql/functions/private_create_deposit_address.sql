drop function if exists deribit.private_create_deposit_address;
create or replace function deribit.private_create_deposit_address(
	currency deribit.private_create_deposit_address_request_currency
)
returns deribit.private_create_deposit_address_response_result
language plpgsql
as $$
declare
	_request deribit.private_create_deposit_address_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/create_deposit_address');
    
_request := row(
		currency
    )::deribit.private_create_deposit_address_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/create_deposit_address', _request);

    return (jsonb_populate_record(
        null::deribit.private_create_deposit_address_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_create_deposit_address is 'Creates deposit address in currency';

