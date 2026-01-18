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

select plan(15);

-- Test 1: private_buy exists
select has_function(
    'deribit',
    'private_buy',
    'private_buy endpoint should exist'
);

-- Test 2: private_sell exists
select has_function(
    'deribit',
    'private_sell',
    'private_sell endpoint should exist'
);

-- Test 3: private_cancel exists
select has_function(
    'deribit',
    'private_cancel',
    'private_cancel endpoint should exist'
);

-- Test 4: private_cancel_by_label exists
select has_function(
    'deribit',
    'private_cancel_by_label',
    'private_cancel_by_label endpoint should exist'
);

-- Test 5: private_cancel_all_by_currency_pair exists
select has_function(
    'deribit',
    'private_cancel_all_by_currency_pair',
    'private_cancel_all_by_currency_pair endpoint should exist'
);

-- Test 6: private_edit exists
select has_function(
    'deribit',
    'private_edit',
    'private_edit endpoint should exist'
);

-- Test 7: private_edit_by_label exists
select has_function(
    'deribit',
    'private_edit_by_label',
    'private_edit_by_label endpoint should exist'
);

-- Test 8: private_close_position exists
select has_function(
    'deribit',
    'private_close_position',
    'private_close_position endpoint should exist'
);

-- Test 9: private_get_open_orders exists
select has_function(
    'deribit',
    'private_get_open_orders',
    'private_get_open_orders endpoint should exist'
);

-- Test 10: private_get_open_orders_by_currency exists
select has_function(
    'deribit',
    'private_get_open_orders_by_currency',
    'private_get_open_orders_by_currency endpoint should exist'
);

-- Test 11: private_get_open_orders_by_instrument exists
select has_function(
    'deribit',
    'private_get_open_orders_by_instrument',
    'private_get_open_orders_by_instrument endpoint should exist'
);

-- Test 12: private_get_order_history_by_currency exists
select has_function(
    'deribit',
    'private_get_order_history_by_currency',
    'private_get_order_history_by_currency endpoint should exist'
);

-- Test 13: private_get_order_history_by_instrument exists
select has_function(
    'deribit',
    'private_get_order_history_by_instrument',
    'private_get_order_history_by_instrument endpoint should exist'
);

-- Test 14: private_cancel_quotes exists
select has_function(
    'deribit',
    'private_cancel_quotes',
    'private_cancel_quotes endpoint should exist'
);

-- Test 15: private_enable_cancel_on_disconnect exists
select has_function(
    'deribit',
    'private_enable_cancel_on_disconnect',
    'private_enable_cancel_on_disconnect endpoint should exist'
);

select * from finish();
rollback;
