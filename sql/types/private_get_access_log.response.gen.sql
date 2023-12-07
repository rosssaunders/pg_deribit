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
drop type if exists deribit.private_get_access_log_response_result cascade;

create type deribit.private_get_access_log_response_result as (
    city text,
    country text,
    data text,
    id bigint,
    ip text,
    log text,
    "timestamp" bigint
);

comment on column deribit.private_get_access_log_response_result.city is 'City where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result.country is 'Country where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result.data is 'Optional, additional information about action, type depends on log value';
comment on column deribit.private_get_access_log_response_result.id is 'Unique identifier';
comment on column deribit.private_get_access_log_response_result.ip is 'IP address of source that generated action';
comment on column deribit.private_get_access_log_response_result.log is 'Action description, values: changed_email - email was changed; changed_password - password was changed; disabled_tfa - TFA was disabled; enabled_tfa - TFA was enabled, success - successful login; failure - login failure; enabled_subaccount_login - login was enabled for subaccount (in data - subaccount uid); disabled_subaccount_login - login was disabled for subbaccount (in data - subbacount uid);new_api_key - API key was created (in data key client id); removed_api_key - API key was removed (in data key client id); changed_scope - scope of API key was changed (in data key client id); changed_whitelist - whitelist of API key was edited (in data key client id); disabled_api_key - API key was disabled (in data key client id); enabled_api_key - API key was enabled (in data key client id); reset_api_key - API key was reset (in data key client id)';
comment on column deribit.private_get_access_log_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

drop type if exists deribit.private_get_access_log_response cascade;

create type deribit.private_get_access_log_response as (
    id bigint,
    jsonrpc text,
    result deribit.private_get_access_log_response_result[]
);

comment on column deribit.private_get_access_log_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_access_log_response.jsonrpc is 'The JSON-RPC version (2.0)';

