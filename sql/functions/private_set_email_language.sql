drop function if exists deribit.private_set_email_language;

create or replace function deribit.private_set_email_language(
	language text
)
returns text
language sql
as $$
    
    with request as (
        select row(
			language
        )::deribit.private_set_email_language_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/set_email_language'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_set_email_language_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_set_email_language is 'Changes the language to be used for emails.';

