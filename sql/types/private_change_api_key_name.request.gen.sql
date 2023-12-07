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
drop type if exists deribit.private_change_api_key_name_request cascade;

create type deribit.private_change_api_key_name_request as (
    id bigint,
    name text
);

comment on column deribit.private_change_api_key_name_request.id is '(Required) Id of key';
comment on column deribit.private_change_api_key_name_request.name is '(Required) Name of key (only letters, numbers and underscores allowed; maximum length - 16 characters)';
