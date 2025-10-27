-- Authenticated Integration Tests
-- Tests critical endpoints with TestNet credentials
-- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET to be set as psql variables
--
-- Usage:
--   psql -v client_id="your_id" -v client_secret="your_secret" -f 09-authenticated-tests.sql
--
-- Or set in the database:
--   ALTER DATABASE deribit SET deribit.test_client_id = 'your_id';
--   ALTER DATABASE deribit SET deribit.test_client_secret = 'your_secret';

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

\c

begin;

select plan(15);

-- Setup: Enable TestNet and set authentication
select deribit.enable_test_net();

-- Set authentication using psql variables or database settings
-- This will use :client_id and :client_secret if passed via -v flag
-- Otherwise tries to use database settings
DO $$
DECLARE
    v_client_id text;
    v_client_secret text;
BEGIN
    -- Try psql variables first (passed via -v)
    BEGIN
        v_client_id := current_setting('deribit.test_client_id');
        v_client_secret := current_setting('deribit.test_client_secret');
    EXCEPTION WHEN undefined_object THEN
        RAISE EXCEPTION 'Authentication credentials not found. Set via: ALTER DATABASE deribit SET deribit.test_client_id = ''your_id'';';
    END;

    -- Set the auth
    PERFORM deribit.set_client_auth(v_client_id, v_client_secret);
END $$;

-- Test 1: Authentication - Verify credentials work by calling an authenticated endpoint
select lives_ok(
    $$SELECT deribit.private_get_account_summary('BTC'::text, false::boolean)$$,
    'Should successfully authenticate and call private endpoint on TestNet'
);

-- Test 2: Account Summary - Core account data
select ok(
    (select jsonb_typeof(deribit.private_get_account_summary('BTC'::text, false::boolean)) = 'object'),
    'Should retrieve account summary for BTC'
);

-- Test 3: Positions - Get all positions
select lives_ok(
    $$select * from deribit.private_get_positions('BTC'::text, 'option'::text)$$,
    'Should retrieve positions without error'
);

-- Test 4: Open Orders - Get open orders
select lives_ok(
    $$select * from deribit.private_get_open_orders_by_currency('BTC'::text, 'option'::text, null)$$,
    'Should retrieve open orders by currency'
);

-- Test 5: Order History - Get order history
select lives_ok(
    $$select * from deribit.private_get_order_history_by_currency('BTC'::text, 'option'::text, null, null, null, null, null)$$,
    'Should retrieve order history by currency'
);

-- Test 6: User Trades - Get user trades
select lives_ok(
    $$select * from deribit.private_get_user_trades_by_currency('BTC'::text, 'option'::text, null, null, null, null, null)$$,
    'Should retrieve user trades by currency'
);

-- Test 7: Deposits - Get deposit history
select lives_ok(
    $$select * from deribit.private_get_deposits('BTC'::text, null, null)$$,
    'Should retrieve deposit history'
);

-- Test 8: Withdrawals - Get withdrawal history
select lives_ok(
    $$select * from deribit.private_get_withdrawals('BTC'::text, null, null)$$,
    'Should retrieve withdrawal history'
);

-- Test 9: Transfers - Get transfer history
select lives_ok(
    $$select * from deribit.private_get_transfers('BTC'::text, null, null)$$,
    'Should retrieve transfer history'
);

-- Test 10: Instruments - Public data works with auth
select ok(
    (select count(*) > 0 from deribit.public_get_instruments('BTC'::text, 'option'::text, false::boolean)),
    'Should retrieve instruments (public endpoint with auth session)'
);

-- Test 11: Currencies - Public data
select ok(
    (select count(*) > 0 from deribit.public_get_currencies()),
    'Should retrieve currencies'
);

-- Test 12: Get Time - Verify server connectivity
select ok(
    (select deribit.public_get_time() > 0),
    'Should get valid server timestamp'
);

-- Test 13: Address Book - Get address book
select lives_ok(
    $$select * from deribit.private_get_address_book('BTC'::text, null)$$,
    'Should retrieve address book'
);

-- Test 14: Subaccounts - Get subaccounts (if any)
select lives_ok(
    $$select * from deribit.private_get_subaccounts(null)$$,
    'Should retrieve subaccounts'
);

-- Test 15: API Keys - List API keys
select lives_ok(
    $$select * from deribit.private_list_api_keys()$$,
    'Should list API keys'
);

select * from finish();
rollback;
