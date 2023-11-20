drop function if exists deribit.private_get_email_language;
create or replace function deribit.private_get_email_language()
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_email_language');
    

    _http_response := deribit.internal_jsonrpc_request('/private/get_email_language', null::text);

    return (jsonb_populate_record(
        null::deribit.private_get_email_language_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_email_language is 'Retrieves the language to be used for emails.';

