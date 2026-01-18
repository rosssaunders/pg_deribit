-- Broker + reward endpoint existence tests

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

-- Test 1: private_get_broker_trade_requests exists
select has_function(
    'deribit',
    'private_get_broker_trade_requests',
    'private_get_broker_trade_requests endpoint should exist'
);

-- Test 2: private_get_broker_trades exists
select has_function(
    'deribit',
    'private_get_broker_trades',
    'private_get_broker_trades endpoint should exist'
);

-- Test 3: private_get_block_trade_requests exists
select has_function(
    'deribit',
    'private_get_block_trade_requests',
    'private_get_block_trade_requests endpoint should exist'
);

-- Test 4: private_get_reward_eligibility exists
select has_function(
    'deribit',
    'private_get_reward_eligibility',
    'private_get_reward_eligibility endpoint should exist'
);

select * from finish();
rollback;
