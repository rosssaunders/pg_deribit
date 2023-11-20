drop function if exists deribit.private_change_api_key_name;
create or replace function deribit.private_change_api_key_name(
	id bigint,
	name text
)
returns deribit.private_change_api_key_name_response_result
language plpgsql
as $$
declare
	_request deribit.private_change_api_key_name_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/change_api_key_name');
    
_request := row(
		id,
		name
    )::deribit.private_change_api_key_name_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/change_api_key_name', _request);

    return (jsonb_populate_record(
        null::deribit.private_change_api_key_name_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_change_api_key_name is 'Changes name for key with given id. Important notes.';

