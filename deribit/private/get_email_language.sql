create type deribit.private_get_email_language_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_get_email_language_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_email_language_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_email_language_response.result is 'The abbreviation of the language';

create or replace function deribit.private_get_email_language()
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= (select deribit.jsonrpc_request('/private/get_email_language', null));

    return (jsonb_populate_record(
        null::deribit.private_get_email_language_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_get_email_language is 'Retrieves the language to be used for emails.';

