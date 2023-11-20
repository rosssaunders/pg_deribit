drop function if exists deribit.private_list_api_keys;
create or replace function deribit.private_list_api_keys()
returns setof deribit.private_list_api_keys_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/list_api_keys');
    

    _http_response := deribit.internal_jsonrpc_request('/private/list_api_keys', null::text);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_list_api_keys_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_list_api_keys is 'Retrieves list of api keys. Important notes.';

