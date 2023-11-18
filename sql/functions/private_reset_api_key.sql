create or replace function deribit.private_reset_api_key(
	id bigint
)
returns deribit.private_reset_api_key_response_result
language plpgsql
as $$
declare
	_request deribit.private_reset_api_key_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		id
    )::deribit.private_reset_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/reset_api_key', _request);

    return (jsonb_populate_record(
        null::deribit.private_reset_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_reset_api_key is 'Resets secret in api key. Important notes.';

