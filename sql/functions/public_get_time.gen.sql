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
drop function if exists deribit.public_get_time;

create or replace function deribit.public_get_time()
returns bigint
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_time'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (jsonb_populate_record(
        null::deribit.public_get_time_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_time is 'Retrieves the current time (in milliseconds). This API endpoint can be used to check the clock skew between your software and Deribit''s systems.';
