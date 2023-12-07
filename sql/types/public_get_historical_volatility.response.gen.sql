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
drop type if exists deribit.public_get_historical_volatility_response_result cascade;

create type deribit.public_get_historical_volatility_response_result as (
    "timestamp" bigint,
    value double precision
);



drop type if exists deribit.public_get_historical_volatility_response cascade;

create type deribit.public_get_historical_volatility_response as (
    id bigint,
    jsonrpc text,
    result double precision[][]
);

comment on column deribit.public_get_historical_volatility_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_historical_volatility_response.jsonrpc is 'The JSON-RPC version (2.0)';

