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
drop type if exists deribit.public_get_last_trades_by_currency_request_currency cascade;

create type deribit.public_get_last_trades_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'USDC',
    'USDT'
);

drop type if exists deribit.public_get_last_trades_by_currency_request_kind cascade;

create type deribit.public_get_last_trades_by_currency_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

drop type if exists deribit.public_get_last_trades_by_currency_request_sorting cascade;

create type deribit.public_get_last_trades_by_currency_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

drop type if exists deribit.public_get_last_trades_by_currency_request cascade;

create type deribit.public_get_last_trades_by_currency_request as (
    currency deribit.public_get_last_trades_by_currency_request_currency,
    kind deribit.public_get_last_trades_by_currency_request_kind,
    start_id text,
    end_id text,
    start_timestamp bigint,
    end_timestamp bigint,
    count bigint,
    sorting deribit.public_get_last_trades_by_currency_request_sorting
);

comment on column deribit.public_get_last_trades_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_last_trades_by_currency_request.kind is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.public_get_last_trades_by_currency_request.start_id is 'The ID of the first trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.public_get_last_trades_by_currency_request.end_id is 'The ID of the last trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.public_get_last_trades_by_currency_request.start_timestamp is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.public_get_last_trades_by_currency_request.end_timestamp is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.public_get_last_trades_by_currency_request.count is 'Number of requested items, default - 10';
comment on column deribit.public_get_last_trades_by_currency_request.sorting is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';
