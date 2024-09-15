/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_email_language_request as (
    "language" text
);

comment on column deribit.private_set_email_language_request."language" is '(Required) The abbreviated language name. Valid values include "en", "ko", "zh", "ja", "ru"';

create type deribit.private_set_email_language_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_set_email_language_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_email_language_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_language_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_set_email_language(
    auth deribit.auth
,    "language" text
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "language"
        )::deribit.private_set_email_language_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/set_email_language'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_set_email_language_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_set_email_language is 'Changes the language to be used for emails.';
