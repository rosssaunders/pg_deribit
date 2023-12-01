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
drop type if exists deribit.private_create_deposit_address_response_result cascade;

create type deribit.private_create_deposit_address_response_result as (
    address text,
    creation_timestamp bigint,
    currency text,
    type text
);

comment on column deribit.private_create_deposit_address_response_result.address is 'Address in proper format for currency';
comment on column deribit.private_create_deposit_address_response_result.creation_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_create_deposit_address_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_create_deposit_address_response_result.type is 'Address type/purpose, allowed values : deposit, withdrawal, transfer';

drop type if exists deribit.private_create_deposit_address_response cascade;

create type deribit.private_create_deposit_address_response as (
    id bigint,
    jsonrpc text,
    result deribit.private_create_deposit_address_response_result
);

comment on column deribit.private_create_deposit_address_response.id is 'The id that was sent in the request';
comment on column deribit.private_create_deposit_address_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_create_deposit_address_response.result is 'Object if address is created, null otherwise';

drop type if exists deribit.private_create_deposit_address_request_currency cascade;

create type deribit.private_create_deposit_address_request_currency as enum (
    'BTC',
    'ETH',
    'USDC',
    'USDT'
);

drop type if exists deribit.private_create_deposit_address_request cascade;

create type deribit.private_create_deposit_address_request as (
    currency deribit.private_create_deposit_address_request_currency
);

comment on column deribit.private_create_deposit_address_request.currency is '(Required) The currency symbol';
