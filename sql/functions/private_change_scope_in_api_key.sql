create or replace function deribit.private_change_scope_in_api_key(
	max_scope text,
	id bigint
)
returns deribit.private_change_scope_in_api_key_response_result
language plpgsql
as $$
declare
	_request deribit.private_change_scope_in_api_key_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		max_scope,
		id
    )::deribit.private_change_scope_in_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/change_scope_in_api_key', _request);

    return (jsonb_populate_record(
        null::deribit.private_change_scope_in_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_change_scope_in_api_key is 'Changes scope for key with given id. Important notes.';

