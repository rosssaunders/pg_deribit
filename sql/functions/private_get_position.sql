drop function if exists deribit.private_get_position;
create or replace function deribit.private_get_position(
	instrument_name text
)
returns deribit.private_get_position_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_position_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_position');
    
_request := row(
		instrument_name
    )::deribit.private_get_position_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_position', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_position_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_position is 'Retrieve user position.';

