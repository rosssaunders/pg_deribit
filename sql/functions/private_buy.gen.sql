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
drop function if exists deribit.private_buy;

create or replace function deribit.private_buy(
    instrument_name text,
    amount double precision,
    type deribit.private_buy_request_type default null,
    label text default null,
    price double precision default null,
    time_in_force deribit.private_buy_request_time_in_force default null,
    max_show double precision default null,
    post_only boolean default null,
    reject_post_only boolean default null,
    reduce_only boolean default null,
    trigger_price double precision default null,
    trigger_offset double precision default null,
    trigger deribit.private_buy_request_trigger default null,
    advanced deribit.private_buy_request_advanced default null,
    mmp boolean default null,
    valid_until bigint default null
)
returns deribit.private_buy_response_result
language sql
as $$
    
    with request as (
        select row(
            instrument_name,
            amount,
            type,
            label,
            price,
            time_in_force,
            max_show,
            post_only,
            reject_post_only,
            reduce_only,
            trigger_price,
            trigger_offset,
            trigger,
            advanced,
            mmp,
            valid_until
        )::deribit.private_buy_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/buy'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_buy_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_buy is 'Places a buy order for an instrument.';
