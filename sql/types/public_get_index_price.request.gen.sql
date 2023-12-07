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
drop type if exists deribit.public_get_index_price_request_index_name cascade;

create type deribit.public_get_index_price_request_index_name as enum (
    'ada_usd',
    'ada_usdc',
    'algo_usd',
    'algo_usdc',
    'avax_usd',
    'avax_usdc',
    'bch_usd',
    'bch_usdc',
    'btc_usd',
    'btc_usdc',
    'btcdvol_usdc',
    'doge_usd',
    'doge_usdc',
    'dot_usd',
    'dot_usdc',
    'eth_usd',
    'eth_usdc',
    'ethdvol_usdc',
    'link_usd',
    'link_usdc',
    'ltc_usd',
    'ltc_usdc',
    'matic_usd',
    'matic_usdc',
    'near_usd',
    'near_usdc',
    'shib_usd',
    'shib_usdc',
    'sol_usd',
    'sol_usdc',
    'trx_usd',
    'trx_usdc',
    'uni_usd',
    'uni_usdc',
    'usdc_usd',
    'xrp_usd',
    'xrp_usdc'
);

drop type if exists deribit.public_get_index_price_request cascade;

create type deribit.public_get_index_price_request as (
    index_name deribit.public_get_index_price_request_index_name
);

comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';
