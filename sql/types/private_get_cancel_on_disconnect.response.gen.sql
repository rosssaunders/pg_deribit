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
drop type if exists deribit.private_get_cancel_on_disconnect_response_result cascade;

create type deribit.private_get_cancel_on_disconnect_response_result as (
    enabled boolean,
    scope text
);

comment on column deribit.private_get_cancel_on_disconnect_response_result.enabled is 'Current configuration status';
comment on column deribit.private_get_cancel_on_disconnect_response_result.scope is 'Informs if Cancel on Disconnect was checked for the current connection or the account';

drop type if exists deribit.private_get_cancel_on_disconnect_response cascade;

create type deribit.private_get_cancel_on_disconnect_response as (
    id bigint,
    jsonrpc text,
    result deribit.private_get_cancel_on_disconnect_response_result
);

comment on column deribit.private_get_cancel_on_disconnect_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_cancel_on_disconnect_response.jsonrpc is 'The JSON-RPC version (2.0)';

