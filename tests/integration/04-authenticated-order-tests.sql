-- Order Operations Tests
-- Tests order placement, cancellation, and position management on TestNet
-- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET to be set
--
-- Usage:
--   Set in the database:
--   ALTER DATABASE deribit SET deribit.test_client_id = 'your_id';
--   ALTER DATABASE deribit SET deribit.test_client_secret = 'your_secret';

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

\c

begin;

select plan(10);

-- Setup: Enable TestNet and set authentication
select deribit.enable_test_net();

-- Set authentication using database settings (set by workflow)
DO $$
DECLARE
    v_client_id text;
    v_client_secret text;
BEGIN
    -- Get credentials from database settings (set by ALTER DATABASE in workflow)
    BEGIN
        v_client_id := current_setting('deribit.test_client_id');
        v_client_secret := current_setting('deribit.test_client_secret');
    EXCEPTION WHEN undefined_object THEN
        RAISE EXCEPTION 'Authentication credentials not found. Set via: ALTER DATABASE deribit SET deribit.test_client_id = ''your_id'';';
    END;

    -- Set the auth for this session
    PERFORM deribit.set_client_auth(v_client_id, v_client_secret);
END $$;

-- Test 1: Place a single limit buy order
select lives_ok(
    $$
    SELECT (t."order").order_id
    FROM deribit.private_buy(
        instrument_name := 'BTC-PERPETUAL',
        amount := 10,
        type := 'limit',
        time_in_force := 'good_til_cancelled',
        post_only := true,
        price := 10000.0,  -- Very low price to avoid execution
        reject_post_only := false,
        label := 'test_order_1'
    ) as t
    $$,
    'Should successfully place a limit buy order'
);

-- Test 2: Place multiple orders using generate_series
select lives_ok(
    $$
    SELECT (t."order").order_id
    FROM generate_series(1, 3) as s(i)
    LEFT JOIN LATERAL deribit.private_buy(
        instrument_name := 'BTC-PERPETUAL',
        amount := 10,
        type := 'limit',
        time_in_force := 'good_til_cancelled',
        post_only := true,
        price := 10000.0 + s.i,  -- Incrementing prices
        reject_post_only := false,
        label := 'test_order_' || s.i::text
    ) as t ON true
    $$,
    'Should successfully place multiple orders via generate_series'
);

-- Test 3: Get open orders by instrument
select ok(
    (SELECT count(*) > 0
     FROM deribit.private_get_open_orders_by_instrument('BTC-PERPETUAL', null)),
    'Should retrieve open orders for BTC-PERPETUAL'
);

-- Test 4: Get open orders by currency
select ok(
    (SELECT count(*) > 0
     FROM deribit.private_get_open_orders_by_currency('BTC', 'future', null)),
    'Should retrieve open orders for BTC currency'
);

-- Test 5: Place a sell order
select lives_ok(
    $$
    SELECT (t."order").order_id
    FROM deribit.private_sell(
        instrument_name := 'BTC-PERPETUAL',
        amount := 10,
        type := 'limit',
        time_in_force := 'good_til_cancelled',
        post_only := true,
        price := 130000.0,  -- High price to avoid execution (below max price limit)
        reject_post_only := false,
        label := 'test_sell_order'
    ) as t
    $$,
    'Should successfully place a limit sell order'
);

-- Test 6: Cancel a specific order
select lives_ok(
    $$
    WITH order_to_cancel AS (
        SELECT order_id
        FROM deribit.private_get_open_orders_by_instrument('BTC-PERPETUAL', null)
        LIMIT 1
    )
    SELECT *
    FROM order_to_cancel,
         deribit.private_cancel(order_to_cancel.order_id)
    $$,
    'Should successfully cancel a specific order'
);

-- Test 7: Cancel all orders
select lives_ok(
    $$SELECT * FROM deribit.private_cancel_all(false)$$,
    'Should successfully cancel all orders'
);

-- Test 8: Verify all orders are cancelled
select ok(
    (SELECT count(*) = 0
     FROM deribit.private_get_open_orders_by_instrument('BTC-PERPETUAL', null)),
    'Should have no open orders after cancel_all'
);

-- Test 9: Verify buy response includes new trade allocation fields
-- Place an order and verify the response structure includes the new fields
select lives_ok(
    $$
    WITH order_response AS (
        SELECT t.*
        FROM deribit.private_buy(
            instrument_name := 'BTC-PERPETUAL',
            amount := 10,
            type := 'limit',
            time_in_force := 'good_til_cancelled',
            post_only := true,
            price := 10000.0,
            reject_post_only := false,
            label := 'test_allocation_check'
        ) as t
    )
    SELECT
        (order_response."order").order_id,
        -- Verify trades field exists (will be empty array for unfilled order)
        (order_response).trades
    FROM order_response
    $$,
    'Should retrieve order response with trades structure (new allocation support)'
);

-- Test 10: Clean up the test order
select lives_ok(
    $$
    WITH order_to_cancel AS (
        SELECT order_id
        FROM deribit.private_get_open_orders_by_instrument('BTC-PERPETUAL', null)
        WHERE label = 'test_allocation_check'
        LIMIT 1
    )
    SELECT *
    FROM order_to_cancel,
         deribit.private_cancel(order_to_cancel.order_id)
    WHERE order_to_cancel.order_id IS NOT NULL
    $$,
    'Should clean up allocation test order'
);

select * from finish();
rollback;
