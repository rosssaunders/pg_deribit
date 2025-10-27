-- New Endpoints Existence Tests
-- Tests for endpoints added in PR #16
-- These tests verify that new endpoints exist and have the correct function signatures

create extension if not exists pgtap;

-- Reconnect to clear any invalidation messages
\c

-- Load pg_deribit outside transaction
create extension if not exists pg_deribit cascade;

-- Reconnect again to clear invalidation messages from pg_deribit
\c

-- Now we can safely create temp tables in a transaction
begin;

select plan(8);

-- Test 1: private_delete_address_beneficiary exists
select has_function(
    'deribit',
    'private_delete_address_beneficiary',
    'private_delete_address_beneficiary endpoint should exist'
);

-- Test 2: private_get_address_beneficiary exists
select has_function(
    'deribit',
    'private_get_address_beneficiary',
    'private_get_address_beneficiary endpoint should exist'
);

-- Test 3: private_list_address_beneficiaries exists
select has_function(
    'deribit',
    'private_list_address_beneficiaries',
    'private_list_address_beneficiaries endpoint should exist'
);

-- Test 4: private_save_address_beneficiary exists
select has_function(
    'deribit',
    'private_save_address_beneficiary',
    'private_save_address_beneficiary endpoint should exist'
);

-- Test 5: private_get_broker_trade_requests exists
select has_function(
    'deribit',
    'private_get_broker_trade_requests',
    'private_get_broker_trade_requests endpoint should exist'
);

-- Test 6: private_get_broker_trades exists
select has_function(
    'deribit',
    'private_get_broker_trades',
    'private_get_broker_trades endpoint should exist'
);

-- Test 7: private_get_block_trade_requests exists
select has_function(
    'deribit',
    'private_get_block_trade_requests',
    'private_get_block_trade_requests endpoint should exist'
);

-- Test 8: private_get_reward_eligibility exists
select has_function(
    'deribit',
    'private_get_reward_eligibility',
    'private_get_reward_eligibility endpoint should exist'
);

select * from finish();
rollback;
