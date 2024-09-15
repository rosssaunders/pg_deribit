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
create type deribit.private_get_cancel_on_disconnect_request_scope as enum (
    'account',
    'connection'
);

create type deribit.private_get_cancel_on_disconnect_request as (
    "scope" deribit.private_get_cancel_on_disconnect_request_scope
);

comment on column deribit.private_get_cancel_on_disconnect_request."scope" is 'Specifies if Cancel On Disconnect change should be applied/checked for the current connection or the account (default - connection)  NOTICE: Scope connection can be used only when working via Websocket.';

create type deribit.private_get_cancel_on_disconnect_response_result as (
    "enabled" boolean,
    "scope" text
);

comment on column deribit.private_get_cancel_on_disconnect_response_result."enabled" is 'Current configuration status';
comment on column deribit.private_get_cancel_on_disconnect_response_result."scope" is 'Informs if Cancel on Disconnect was checked for the current connection or the account';

create type deribit.private_get_cancel_on_disconnect_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_cancel_on_disconnect_response_result
);

comment on column deribit.private_get_cancel_on_disconnect_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_cancel_on_disconnect_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_cancel_on_disconnect(
    auth deribit.auth
,    "scope" deribit.private_get_cancel_on_disconnect_request_scope default null
)
returns deribit.private_get_cancel_on_disconnect_response_result
language sql
as $$
    
    with request as (
        select row(
            "scope"
        )::deribit.private_get_cancel_on_disconnect_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/get_cancel_on_disconnect'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_get_cancel_on_disconnect_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_cancel_on_disconnect is 'Read current Cancel On Disconnect configuration for the account.';
