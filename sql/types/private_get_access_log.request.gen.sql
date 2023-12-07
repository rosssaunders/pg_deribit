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
drop type if exists deribit.private_get_access_log_request cascade;

create type deribit.private_get_access_log_request as (
    "offset" bigint,
    count bigint
);

comment on column deribit.private_get_access_log_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.private_get_access_log_request.count is 'Number of requested items, default - 10';
