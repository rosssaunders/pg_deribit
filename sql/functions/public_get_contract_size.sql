drop function if exists deribit.public_get_contract_size;
create or replace function deribit.public_get_contract_size(
	instrument_name text
)
returns deribit.public_get_contract_size_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_contract_size_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_contract_size');
    
_request := row(
		instrument_name
    )::deribit.public_get_contract_size_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_contract_size', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_contract_size_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_contract_size is 'Retrieves contract size of provided instrument.';

