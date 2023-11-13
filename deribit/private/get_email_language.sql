insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_email_language', now(), 0, '0 secs'::interval);

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
    
    _http_response:= deribit.internal_jsonrpc_request('/private/get_email_language');

    return (jsonb_populate_record(
        null::deribit.private_get_email_language_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_email_language is 'Retrieves the language to be used for emails.';

