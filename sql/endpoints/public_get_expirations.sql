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
create type deribit.public_get_expirations_request_currency as enum (
    'BTC',
    'ETH',
    'USDC',
    'USDT',
    'any',
    'grouped'
);

create type deribit.public_get_expirations_request_kind as enum (
    'any',
    'future',
    'option'
);

create type deribit.public_get_expirations_request_currency_pair as enum (
    'ada_usd',
    'ada_usdc',
    'ada_usdt',
    'algo_usd',
    'algo_usdc',
    'algo_usdt',
    'avax_usd',
    'avax_usdc',
    'avax_usdt',
    'bch_usd',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usde',
    'btc_usdt',
    'btc_usyc',
    'btcdvol_usdc',
    'doge_usd',
    'doge_usdc',
    'doge_usdt',
    'dot_usd',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usde',
    'eth_usdt',
    'eth_usyc',
    'ethdvol_usdc',
    'link_usd',
    'link_usdc',
    'link_usdt',
    'ltc_usd',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usd',
    'matic_usdc',
    'matic_usdt',
    'near_usd',
    'near_usdc',
    'near_usdt',
    'paxg_btc',
    'paxg_usd',
    'paxg_usdc',
    'paxg_usdt',
    'shib_usd',
    'shib_usdc',
    'shib_usdt',
    'sol_usd',
    'sol_usdc',
    'sol_usdt',
    'steth_eth',
    'steth_usd',
    'steth_usdc',
    'steth_usdt',
    'trx_usd',
    'trx_usdc',
    'trx_usdt',
    'uni_usd',
    'uni_usdc',
    'uni_usdt',
    'usdc_usd',
    'usde_usd',
    'usde_usdc',
    'usde_usdt',
    'usyc_usdc',
    'xrp_usd',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.public_get_expirations_request as (
    "currency" deribit.public_get_expirations_request_currency,
    "kind" deribit.public_get_expirations_request_kind,
    "currency_pair" deribit.public_get_expirations_request_currency_pair
);

comment on column deribit.public_get_expirations_request."currency" is '(Required) The currency symbol or "any" for all or ''"grouped"'' for all grouped by currency';
comment on column deribit.public_get_expirations_request."kind" is '(Required) Instrument kind, "future" or "option" or "any"';
comment on column deribit.public_get_expirations_request."currency_pair" is 'The currency pair symbol';

create type deribit.public_get_expirations_response_result as (
    "currency" text,
    "kind" text
);

comment on column deribit.public_get_expirations_response_result."currency" is 'Currency name or "any" if don''t care or "grouped" if grouped by currencies';
comment on column deribit.public_get_expirations_response_result."kind" is 'Instrument kind: "future", "option" or "any" for all';

create type deribit.public_get_expirations_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_expirations_response_result[]
);

comment on column deribit.public_get_expirations_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_expirations_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_expirations_response."result" is 'A map where each key is valid currency (e.g. btc, eth, usdc), and the value is a list of expirations or a map where each key is a valid kind (future or options) and value is a list of expirations from every instrument';

create function deribit.public_get_expirations(
    "currency" deribit.public_get_expirations_request_currency,
    "kind" deribit.public_get_expirations_request_kind,
    "currency_pair" deribit.public_get_expirations_request_currency_pair default null
)
returns setof deribit.public_get_expirations_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "currency_pair"
        )::deribit.public_get_expirations_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_expirations'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_expirations_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."currency"::text,
        (b)."kind"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_expirations is 'Retrieves expirations for instruments. This method can be used to see instruments''s expirations.';
