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
drop type if exists deribit.public_get_trade_volumes_request cascade;

create type deribit.public_get_trade_volumes_request as (
    extended boolean
);

comment on column deribit.public_get_trade_volumes_request.extended is 'Request for extended statistics. Including also 7 and 30 days volumes (default false)';
