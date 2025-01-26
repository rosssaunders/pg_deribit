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
create type deribit.public_test_request_expected_result as enum (
    'exception'
);

create type deribit.public_test_request as (
    "expected_result" deribit.public_test_request_expected_result
);

comment on column deribit.public_test_request."expected_result" is 'The value "exception" will trigger an error response. This may be useful for testing wrapper libraries.';

create type deribit.public_test_response_result as (
    "version" text
);

comment on column deribit.public_test_response_result."version" is 'The API version';

create type deribit.public_test_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_test_response_result
);

comment on column deribit.public_test_response."id" is 'The id that was sent in the request';
comment on column deribit.public_test_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_test(
    "expected_result" deribit.public_test_request_expected_result default null
)
returns deribit.public_test_response_result
language sql
as $$
    
    with request as (
        select row(
            "expected_result"
        )::deribit.public_test_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/test'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_test_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_test is 'Tests the connection to the API server, and returns its version. You can use this to make sure the API is reachable, and matches the expected version.';
