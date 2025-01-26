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
create type deribit.public_get_historical_volatility_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_historical_volatility_request as (
    "currency" deribit.public_get_historical_volatility_request_currency
);

comment on column deribit.public_get_historical_volatility_request."currency" is '(Required) The currency symbol';

create type deribit.public_get_historical_volatility_response_result as (
    "timestamp" bigint,
    "value" double precision
);

create type deribit.public_get_historical_volatility_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision[][]
);

comment on column deribit.public_get_historical_volatility_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_historical_volatility_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_historical_volatility(
    "currency" deribit.public_get_historical_volatility_request_currency
)
returns setof deribit.public_get_historical_volatility_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.public_get_historical_volatility_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_historical_volatility'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_historical_volatility_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    , unnested as (
        select deribit.unnest_2d_1d(x.x)
        from result x(x)
    )
    select
        (b.x)[1]::bigint as "timestamp",
        (b.x)[2]::double precision as "value"
    from unnested b(x)
$$;

comment on function deribit.public_get_historical_volatility is 'Provides information about historical volatility for given cryptocurrency.';
