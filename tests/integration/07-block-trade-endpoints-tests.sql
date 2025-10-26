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

select plan(4);

-- Test 1: private_get_block_trades exists
select has_function(
    'deribit',
    'private_get_block_trades',
    'private_get_block_trades endpoint should exist'
);

-- Test 2: private_execute_block_trade exists
select has_function(
    'deribit',
    'private_execute_block_trade',
    'private_execute_block_trade endpoint should exist'
);

-- Test 3: private_get_block_trade exists (modified)
select has_function(
    'deribit',
    'private_get_block_trade',
    'private_get_block_trade endpoint should exist'
);

-- Test 4: Verify private_get_block_trade_requests is new
select has_function(
    'deribit',
    'private_get_block_trade_requests',
    'private_get_block_trade_requests endpoint should exist (new)'
);

select * from finish();
rollback;
