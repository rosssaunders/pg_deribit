drop function if exists deribit.private_disable_api_key;

create or replace function deribit.private_disable_api_key(
	id bigint
)
returns deribit.private_disable_api_key_response_result
language plpgsql
as $$
declare
	_request deribit.private_disable_api_key_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		id
    )::deribit.private_disable_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/disable_api_key'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_disable_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_disable_api_key is 'Disables api key with given id. Important notes.';

