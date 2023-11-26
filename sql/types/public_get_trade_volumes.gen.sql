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
drop type if exists deribit.public_get_trade_volumes_response_result cascade;

create type deribit.public_get_trade_volumes_response_result as (
    calls_volume double precision,
    calls_volume_30d double precision,
    calls_volume_7d double precision,
    currency text,
    futures_volume double precision,
    futures_volume_30d double precision,
    futures_volume_7d double precision,
    puts_volume double precision,
    puts_volume_30d double precision,
    puts_volume_7d double precision,
    spot_volume double precision,
    spot_volume_30d double precision,
    spot_volume_7d double precision
);

comment on column deribit.public_get_trade_volumes_response_result.calls_volume is 'Total 24h trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result.calls_volume_30d is 'Total 30d trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result.calls_volume_7d is 'Total 7d trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.public_get_trade_volumes_response_result.futures_volume is 'Total 24h trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result.futures_volume_30d is 'Total 30d trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result.futures_volume_7d is 'Total 7d trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result.puts_volume is 'Total 24h trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result.puts_volume_30d is 'Total 30d trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result.puts_volume_7d is 'Total 7d trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result.spot_volume is 'Total 24h trade for spot.';
comment on column deribit.public_get_trade_volumes_response_result.spot_volume_30d is 'Total 30d trade for spot.';
comment on column deribit.public_get_trade_volumes_response_result.spot_volume_7d is 'Total 7d trade for spot.';

drop type if exists deribit.public_get_trade_volumes_response cascade;

create type deribit.public_get_trade_volumes_response as (
    id bigint,
    jsonrpc text,
    result deribit.public_get_trade_volumes_response_result[]
);

comment on column deribit.public_get_trade_volumes_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_trade_volumes_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_trade_volumes_request cascade;

create type deribit.public_get_trade_volumes_request as (
    extended boolean
);

comment on column deribit.public_get_trade_volumes_request.extended is 'Request for extended statistics. Including also 7 and 30 days volumes (default false)';
