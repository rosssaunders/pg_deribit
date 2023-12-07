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
drop type if exists deribit.private_get_settlement_history_by_currency_request_currency cascade;

create type deribit.private_get_settlement_history_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'USDC',
    'USDT'
);

drop type if exists deribit.private_get_settlement_history_by_currency_request_type cascade;

create type deribit.private_get_settlement_history_by_currency_request_type as enum (
    'bankruptcy',
    'delivery',
    'settlement'
);

drop type if exists deribit.private_get_settlement_history_by_currency_request cascade;

create type deribit.private_get_settlement_history_by_currency_request as (
    currency deribit.private_get_settlement_history_by_currency_request_currency,
    type deribit.private_get_settlement_history_by_currency_request_type,
    count bigint,
    continuation text,
    search_start_timestamp bigint
);

comment on column deribit.private_get_settlement_history_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_settlement_history_by_currency_request.type is 'Settlement type';
comment on column deribit.private_get_settlement_history_by_currency_request.count is 'Number of requested items, default - 20';
comment on column deribit.private_get_settlement_history_by_currency_request.continuation is 'Continuation token for pagination';
comment on column deribit.private_get_settlement_history_by_currency_request.search_start_timestamp is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';
