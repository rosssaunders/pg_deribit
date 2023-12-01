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
drop function if exists deribit.public_get_combo_details;

create or replace function deribit.public_get_combo_details(
    combo_id text
)
returns deribit.public_get_combo_details_response_result
language sql
as $$
    
    with request as (
        select row(
            combo_id
        )::deribit.public_get_combo_details_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_combo_details'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.public_get_combo_details_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_combo_details is 'Retrieves information about a combo';
