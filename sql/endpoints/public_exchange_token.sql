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
create type deribit.public_exchange_token_request as (
    "refresh_token" text,
    "subject_id" bigint
);

comment on column deribit.public_exchange_token_request."refresh_token" is '(Required) Refresh token';
comment on column deribit.public_exchange_token_request."subject_id" is '(Required) New subject id';

create type deribit.public_exchange_token_response_result as (
    "access_token" text,
    "expires_in" bigint,
    "refresh_token" text,
    "scope" text,
    "sid" text,
    "token_type" text
);

comment on column deribit.public_exchange_token_response_result."expires_in" is 'Token lifetime in seconds';
comment on column deribit.public_exchange_token_response_result."refresh_token" is 'Can be used to request a new token (with a new lifetime)';
comment on column deribit.public_exchange_token_response_result."scope" is 'Type of the access for assigned token';
comment on column deribit.public_exchange_token_response_result."sid" is 'Optional Session id';
comment on column deribit.public_exchange_token_response_result."token_type" is 'Authorization type, allowed value - bearer';

create type deribit.public_exchange_token_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_exchange_token_response_result
);

comment on column deribit.public_exchange_token_response."id" is 'The id that was sent in the request';
comment on column deribit.public_exchange_token_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_exchange_token(
    "refresh_token" text,
    "subject_id" bigint
)
returns deribit.public_exchange_token_response_result
language sql
as $$
    
    with request as (
        select row(
            "refresh_token",
            "subject_id"
        )::deribit.public_exchange_token_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/exchange_token'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_exchange_token_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_exchange_token is 'Generates a token for a new subject id. This method can be used to switch between subaccounts.';
