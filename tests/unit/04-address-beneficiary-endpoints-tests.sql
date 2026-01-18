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

select * from finish();
rollback;
