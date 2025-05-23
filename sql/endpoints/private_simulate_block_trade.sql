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
create type deribit.private_simulate_block_trade_request_trade_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_simulate_block_trade_request_role as enum (
    'maker',
    'taker'
);

create type deribit.private_simulate_block_trade_request_trade as (
    "instrument_name" text,
    "price" double precision,
    "amount" double precision,
    "direction" deribit.private_simulate_block_trade_request_trade_direction
);

comment on column deribit.private_simulate_block_trade_request_trade."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_simulate_block_trade_request_trade."price" is '(Required) Price for trade';
comment on column deribit.private_simulate_block_trade_request_trade."amount" is 'It represents the requested trade size. For perpetual and inverse futures the amount is in USD units. For options and linear futures and it is the underlying base currency coin.';
comment on column deribit.private_simulate_block_trade_request_trade."direction" is '(Required) Direction of trade from the maker perspective';

create type deribit.private_simulate_block_trade_request as (
    "role" deribit.private_simulate_block_trade_request_role,
    "trades" deribit.private_simulate_block_trade_request_trade[]
);

comment on column deribit.private_simulate_block_trade_request."role" is 'Describes if user wants to be maker or taker of trades';
comment on column deribit.private_simulate_block_trade_request."trades" is '(Required) List of trades for block trade';

create type deribit.private_simulate_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" boolean
);

comment on column deribit.private_simulate_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_simulate_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_simulate_block_trade_response."result" is 'true if block trade can be executed, false otherwise';

create function deribit.private_simulate_block_trade(
    "trades" deribit.private_simulate_block_trade_request_trade[],
    "role" deribit.private_simulate_block_trade_request_role default null
)
returns boolean
language sql
as $$
    
    with request as (
        select row(
            "role",
            "trades"
        )::deribit.private_simulate_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/simulate_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_simulate_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_simulate_block_trade is 'Checks if a block trade can be executed';
