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
create type deribit.private_logout_request as (
    "invalidate_token" boolean
);

comment on column deribit.private_logout_request."invalidate_token" is 'If value is true all tokens created in current session are invalidated, default: true';

create type deribit.private_logout_response as (
    "id" bigint,
    "jsonrpc" text
);

create function deribit.private_logout(
    "invalidate_token" boolean default null
)
returns void
language sql
as $$
    
    with request as (
        select row(
            "invalidate_token"
        )::deribit.private_logout_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/logout'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
            select null::void as result
        
$$;

comment on function deribit.private_logout is 'Gracefully close websocket connection, when COD (Cancel On Disconnect) is enabled orders are not cancelled';
