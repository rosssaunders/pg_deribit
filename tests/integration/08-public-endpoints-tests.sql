-- Load pgtap first
create extension if not exists pgtap;

-- Reconnect to clear any invalidation messages
\c

-- Load pg_deribit outside transaction
create extension if not exists pg_deribit cascade;

-- Reconnect again to clear invalidation messages from pg_deribit
\c

-- Now we can safely create temp tables in a transaction
begin;

select plan(10);

-- Test 1: public_get_instruments exists
select has_function(
    'deribit',
    'public_get_instruments',
    'public_get_instruments endpoint should exist'
);

-- Test 2: public_get_order_book exists
select has_function(
    'deribit',
    'public_get_order_book',
    'public_get_order_book endpoint should exist'
);

-- Test 3: public_get_last_trades_by_instrument exists
select has_function(
    'deribit',
    'public_get_last_trades_by_instrument',
    'public_get_last_trades_by_instrument endpoint should exist'
);

-- Test 4: public_get_combo_details exists
select has_function(
    'deribit',
    'public_get_combo_details',
    'public_get_combo_details endpoint should exist'
);

-- Test 5: public_get_combos exists
select has_function(
    'deribit',
    'public_get_combos',
    'public_get_combos endpoint should exist'
);

-- Test 6: public_get_announcements exists
select has_function(
    'deribit',
    'public_get_announcements',
    'public_get_announcements endpoint should exist'
);

-- Test 7: public_get_expirations exists
select has_function(
    'deribit',
    'public_get_expirations',
    'public_get_expirations endpoint should exist'
);

-- Test 8: public_get_delivery_prices exists
select has_function(
    'deribit',
    'public_get_delivery_prices',
    'public_get_delivery_prices endpoint should exist'
);

-- Test 9: public_get_apr_history exists
select has_function(
    'deribit',
    'public_get_apr_history',
    'public_get_apr_history endpoint should exist'
);

-- Test 10: Test a specific modified endpoint works
select ok(
    (select deribit.public_get_time() > 0),
    'public_get_time should return valid timestamp'
);

select * from finish();
rollback;
