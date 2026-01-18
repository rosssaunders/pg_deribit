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

select plan(12);

-- Test 1: private_get_account_summary exists
select has_function(
    'deribit',
    'private_get_account_summary',
    'private_get_account_summary endpoint should exist'
);

-- Test 2: private_get_positions exists
select has_function(
    'deribit',
    'private_get_positions',
    'private_get_positions endpoint should exist'
);

-- Test 3: private_get_position exists
select has_function(
    'deribit',
    'private_get_position',
    'private_get_position endpoint should exist'
);

-- Test 4: private_get_user_trades_by_currency exists
select has_function(
    'deribit',
    'private_get_user_trades_by_currency',
    'private_get_user_trades_by_currency endpoint should exist'
);

-- Test 5: private_get_user_trades_by_instrument exists
select has_function(
    'deribit',
    'private_get_user_trades_by_instrument',
    'private_get_user_trades_by_instrument endpoint should exist'
);

-- Test 6: private_get_user_trades_by_order exists
select has_function(
    'deribit',
    'private_get_user_trades_by_order',
    'private_get_user_trades_by_order endpoint should exist'
);

-- Test 7: private_get_deposits exists
select has_function(
    'deribit',
    'private_get_deposits',
    'private_get_deposits endpoint should exist'
);

-- Test 8: private_get_withdrawals exists
select has_function(
    'deribit',
    'private_get_withdrawals',
    'private_get_withdrawals endpoint should exist'
);

-- Test 9: private_get_transfers exists
select has_function(
    'deribit',
    'private_get_transfers',
    'private_get_transfers endpoint should exist'
);

-- Test 10: private_create_deposit_address exists
select has_function(
    'deribit',
    'private_create_deposit_address',
    'private_create_deposit_address endpoint should exist'
);

-- Test 11: private_get_address_book exists
select has_function(
    'deribit',
    'private_get_address_book',
    'private_get_address_book endpoint should exist'
);

-- Test 12: private_add_to_address_book exists
select has_function(
    'deribit',
    'private_add_to_address_book',
    'private_add_to_address_book endpoint should exist'
);

select * from finish();
rollback;
