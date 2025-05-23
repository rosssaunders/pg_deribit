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
create type deribit.public_status_response_result as (
    "locked" text,
    "locked_indices" text[]
);

comment on column deribit.public_status_response_result."locked" is 'true when platform is locked in all currencies, partial when some currencies are locked, false - when there are not currencies locked';
comment on column deribit.public_status_response_result."locked_indices" is 'List of currency indices locked platform-wise';

create type deribit.public_status_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_status_response_result
);

comment on column deribit.public_status_response."id" is 'The id that was sent in the request';
comment on column deribit.public_status_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_status()
returns deribit.public_status_response_result
language sql
as $$
    with http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/status'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.public_status_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_status is 'Method used to get information about locked currencies';
