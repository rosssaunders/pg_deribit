-- Authenticated feature endpoint tests
-- Covers beneficiary management, broker trades, block trades, rewards, and related enums
-- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET to be set

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

\c

begin;

select plan(12);

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

-- Address Beneficiary Tests

-- Test 1: List address beneficiaries (may be empty)
select lives_ok(
    $$SELECT * FROM deribit.private_list_address_beneficiaries('BTC', null)$$,
    'Should retrieve address beneficiaries list for BTC'
);

-- Test 2: Get address book (existing endpoint, verify still works with required type parameter)
select lives_ok(
    $$SELECT * FROM deribit.private_get_address_book('BTC', 'withdrawal')$$,
    'Should retrieve address book for BTC withdrawals'
);

-- Broker Trade Tests

-- Test 3: Get broker trade requests (requires block_trade:read scope)
-- Expect permission error for accounts without broker/block trade scope
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_get_broker_trade_requests();
        EXCEPTION WHEN OTHERS THEN
            -- Expected: 13021 forbidden (missing scope) or success
            IF SQLERRM NOT LIKE '%13021%' AND SQLERRM NOT LIKE '%forbidden%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should handle broker trade requests endpoint (requires block_trade:read scope)'
);

-- Test 4: Get broker trades (requires block_trade:read scope)
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_get_broker_trades('BTC', null, null, null, null);
        EXCEPTION WHEN OTHERS THEN
            -- Expected: 13021 forbidden (missing scope) or success
            IF SQLERRM NOT LIKE '%13021%' AND SQLERRM NOT LIKE '%forbidden%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should handle broker trades endpoint (requires block_trade:read scope)'
);

-- Block Trade Tests

-- Test 5: Get block trade requests (requires block_trade:read scope)
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_get_block_trade_requests();
        EXCEPTION WHEN OTHERS THEN
            -- Expected: 13021 forbidden (missing scope) or success
            IF SQLERRM NOT LIKE '%13021%' AND SQLERRM NOT LIKE '%forbidden%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should handle block trade requests endpoint (requires block_trade:read scope)'
);

-- Test 6: Get block trades (requires block_trade:read scope)
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_get_block_trades('BTC', null, null, null);
        EXCEPTION WHEN OTHERS THEN
            -- Expected: 13021 forbidden (missing scope) or success
            IF SQLERRM NOT LIKE '%13021%' AND SQLERRM NOT LIKE '%forbidden%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should handle block trades endpoint (requires block_trade:read scope)'
);

-- Test 7: Get pending block trades (requires block_trade:read scope)
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_get_pending_block_trades();
        EXCEPTION WHEN OTHERS THEN
            -- Expected: 13021 forbidden (missing scope) or success
            IF SQLERRM NOT LIKE '%13021%' AND SQLERRM NOT LIKE '%forbidden%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should handle pending block trades endpoint (requires block_trade:read scope)'
);

-- Reward Tests

-- Test 8: Check reward eligibility
select lives_ok(
    $$SELECT * FROM deribit.private_get_reward_eligibility()$$,
    'Should check reward eligibility'
);

-- User Trades with New Fields Tests

-- Test 9: Get user trades by currency (updated with client_info field)
select lives_ok(
    $$SELECT * FROM deribit.private_get_user_trades_by_currency('BTC', 'future', null, null, null, null, null)$$,
    'Should retrieve user trades by currency with new fields'
);

-- Test 10: Get user trades by instrument (updated with client_info field)
select lives_ok(
    $$SELECT * FROM deribit.private_get_user_trades_by_instrument('BTC-PERPETUAL', null, null, null, null, null)$$,
    'Should retrieve user trades by instrument with new fields'
);

-- New Currency Pairs Tests

-- Test 11: Cancel quotes with new currency pair (drbfix-btc_usdc)
-- This will likely return an error if no quotes exist, but verifies the enum accepts the new value
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_cancel_quotes('drbfix-btc_usdc');
        EXCEPTION WHEN OTHERS THEN
            -- Expected to fail if no quotes, but we're testing the enum accepts the value
            IF SQLERRM NOT LIKE '%10004%' AND SQLERRM NOT LIKE '%no_quotes%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should accept new currency pair drbfix-btc_usdc in cancel_quotes'
);

-- Test 12: Cancel all by currency pair with new currency pair
select lives_ok(
    $$
    DO $func$
    BEGIN
        BEGIN
            PERFORM deribit.private_cancel_all_by_currency_pair('drbfix-eth_usdc', null);
        EXCEPTION WHEN OTHERS THEN
            -- Expected to potentially fail if no orders, but we're testing the enum accepts the value
            IF SQLERRM NOT LIKE '%no_orders%' THEN
                RAISE;
            END IF;
        END;
    END $func$
    $$,
    'Should accept new currency pair drbfix-eth_usdc in cancel_all_by_currency_pair'
);

select * from finish();
rollback;
