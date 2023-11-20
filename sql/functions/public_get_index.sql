drop function if exists deribit.public_get_index;
create or replace function deribit.public_get_index(
	currency deribit.public_get_index_request_currency
)
returns deribit.public_get_index_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_index_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_index');
    
_request := row(
		currency
    )::deribit.public_get_index_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_index', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_index_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_index is 'Retrieves the current index price for the instruments, for the selected currency.';

