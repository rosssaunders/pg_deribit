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
drop function if exists deribit.private_get_cancel_on_disconnect;

create or replace function deribit.private_get_cancel_on_disconnect(
    scope deribit.private_get_cancel_on_disconnect_request_scope default null
)
returns deribit.private_get_cancel_on_disconnect_response_result
language sql
as $$
    
    with request as (
        select row(
            scope
        )::deribit.private_get_cancel_on_disconnect_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_cancel_on_disconnect'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_get_cancel_on_disconnect_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_cancel_on_disconnect is 'Read current Cancel On Disconnect configuration for the account.';
