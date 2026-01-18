-- Authenticated Trading Flow Tests (TestNet)
-- Exercises a real buy -> position -> sell flow.
-- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET to be set
--
-- Usage:
--   ALTER DATABASE deribit SET deribit.test_client_id = 'your_id';
--   ALTER DATABASE deribit SET deribit.test_client_secret = 'your_secret';
--
-- NOTE: Use a dedicated TestNet account; this test places real trades.

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

\c

begin;

select plan(9);

-- Setup: Enable TestNet and set authentication
select deribit.enable_test_net();

DO $$
DECLARE
    v_client_id text;
    v_client_secret text;
BEGIN
    BEGIN
        v_client_id := current_setting('deribit.test_client_id');
        v_client_secret := current_setting('deribit.test_client_secret');
    EXCEPTION WHEN undefined_object THEN
        RAISE EXCEPTION 'Authentication credentials not found. Set via: ALTER DATABASE deribit SET deribit.test_client_id = ''your_id'';';
    END;

    PERFORM deribit.set_client_auth(v_client_id, v_client_secret);
END $$;

create temporary table trade_flow_context as
with base as (
    select clock_timestamp() as ts
)
select
    'BTC-PERPETUAL'::text as instrument_name,
    coalesce((deribit.public_get_instrument('BTC-PERPETUAL')).min_trade_amount, 10)::double precision as trade_amount,
    to_char(base.ts, 'YYYYMMDDHH24MISSMS') as label_suffix,
    (extract(epoch from base.ts) * 1000)::bigint as start_ts
from base;

select ok(
    (select (deribit.public_get_instrument((select instrument_name from trade_flow_context))).is_active),
    'Instrument should be active'
);

select ok(
    (select trade_amount > 0 from trade_flow_context),
    'Trade amount should be positive'
);

select ok(
    coalesce(
        (select (deribit.private_get_position((select instrument_name from trade_flow_context))).size),
        0::double precision
    ) = 0::double precision,
    'Starting position should be zero'
);

select ok(
    (
        with ctx as (select * from trade_flow_context)
        select ((buy_response.resp)."order").order_state = 'filled'
            and ((buy_response.resp)."order").order_id is not null
        from (
            select deribit.private_buy(
                instrument_name := ctx.instrument_name,
                amount := ctx.trade_amount,
                type := 'market',
                label := 'pgtap_trade_flow_buy_' || ctx.label_suffix
            ) as resp
            from ctx
        ) as buy_response
    ),
    'Market buy should fill and return an order id'
);

select ok(
    (select coalesce((deribit.private_get_position((select instrument_name from trade_flow_context))).size, 0) > 0),
    'Position should be open after buy'
);

select ok(
    (
        with ctx as (select * from trade_flow_context)
        select ((sell_response.resp)."order").order_state = 'filled'
            and ((sell_response.resp)."order").order_id is not null
        from (
            select deribit.private_sell(
                instrument_name := ctx.instrument_name,
                amount := ctx.trade_amount,
                type := 'market',
                reduce_only := true,
                label := 'pgtap_trade_flow_sell_' || ctx.label_suffix
            ) as resp
            from ctx
        ) as sell_response
    ),
    'Reduce-only market sell should fill and return an order id'
);

select ok(
    coalesce(
        (select (deribit.private_get_position((select instrument_name from trade_flow_context))).size),
        0::double precision
    ) = 0::double precision,
    'Position should be closed after sell'
);

select ok(
    (
        select count(*) >= 1
        from trade_flow_context ctx,
        lateral (
            select unnest(
                coalesce(
                    (deribit.private_get_user_trades_by_instrument(
                        instrument_name := ctx.instrument_name,
                        start_timestamp := ctx.start_ts,
                        sorting := 'asc'
                    )).trades,
                    ARRAY[]::deribit.private_get_user_trades_by_instrument_response_trade[]
                )
            ) as trade
        ) as trades
        where (trades.trade).label = 'pgtap_trade_flow_buy_' || ctx.label_suffix
    ),
    'Trade history should include the buy label'
);

select ok(
    (
        select count(*) >= 1
        from trade_flow_context ctx,
        lateral (
            select unnest(
                coalesce(
                    (deribit.private_get_user_trades_by_instrument(
                        instrument_name := ctx.instrument_name,
                        start_timestamp := ctx.start_ts,
                        sorting := 'asc'
                    )).trades,
                    ARRAY[]::deribit.private_get_user_trades_by_instrument_response_trade[]
                )
            ) as trade
        ) as trades
        where (trades.trade).label = 'pgtap_trade_flow_sell_' || ctx.label_suffix
    ),
    'Trade history should include the sell label'
);

select * from finish();
rollback;
