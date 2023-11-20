drop function if exists deribit.private_create_subaccount;
create or replace function deribit.private_create_subaccount()
returns deribit.private_create_subaccount_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/create_subaccount');
    

    _http_response := deribit.internal_jsonrpc_request('/private/create_subaccount', null::text);

    return (jsonb_populate_record(
        null::deribit.private_create_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_create_subaccount is 'Create a new subaccount';

