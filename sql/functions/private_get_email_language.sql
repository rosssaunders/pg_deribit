drop function if exists deribit.private_get_email_language;

create or replace function deribit.private_get_email_language()
returns text
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_email_language'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	select (jsonb_populate_record(
        null::deribit.private_get_email_language_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_email_language is 'Retrieves the language to be used for emails.';

