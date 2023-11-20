drop function if exists deribit.public_get_instrument;
create or replace function deribit.public_get_instrument(
	instrument_name text
)
returns deribit.public_get_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_instrument_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_instrument');
    
_request := row(
		instrument_name
    )::deribit.public_get_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_instrument', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_instrument is 'Retrieves information about instrument';

