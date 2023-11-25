drop function if exists deribit.private_set_email_language;

create or replace function deribit.private_set_email_language(
	language text
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_set_email_language_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		language
    )::deribit.private_set_email_language_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/set_email_language'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_set_email_language_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_set_email_language is 'Changes the language to be used for emails.';

