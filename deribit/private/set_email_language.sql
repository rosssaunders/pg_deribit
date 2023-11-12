create type deribit.private_set_email_language_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_email_language_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_email_language_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_language_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_set_email_language_request as (
	language text
);
comment on column deribit.private_set_email_language_request.language is '(Required) The abbreviated language name. Valid values include "en", "ko", "zh", "ja", "ru"';

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
    
    _http_response := (select deribit.jsonrpc_request('/private/set_email_language', _request));

    return (jsonb_populate_record(
        null::deribit.private_set_email_language_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_set_email_language is 'Changes the language to be used for emails.';

