drop function if exists deribit.private_create_api_key;
create or replace function deribit.private_create_api_key(
	max_scope text,
	name text default null,
	public_key text default null,
	enabled_features UNKNOWN - array default null
)
returns deribit.private_create_api_key_response_result
language plpgsql
as $$
declare
	_request deribit.private_create_api_key_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/create_api_key');
    
_request := row(
		max_scope,
		name,
		public_key,
		enabled_features
    )::deribit.private_create_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/create_api_key', _request);

    return (jsonb_populate_record(
        null::deribit.private_create_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_create_api_key is 'Creates new api key with given scope. Important notes';

