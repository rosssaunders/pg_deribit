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

select plan(6);

-- Test 1: private_create_api_key exists
select has_function(
    'deribit',
    'private_create_api_key',
    'private_create_api_key endpoint should exist'
);

-- Test 2: private_edit_api_key exists
select has_function(
    'deribit',
    'private_edit_api_key',
    'private_edit_api_key endpoint should exist'
);

-- Test 3: private_list_api_keys exists
select has_function(
    'deribit',
    'private_list_api_keys',
    'private_list_api_keys endpoint should exist'
);

-- Test 4: private_change_scope_in_api_key exists
select has_function(
    'deribit',
    'private_change_scope_in_api_key',
    'private_change_scope_in_api_key endpoint should exist'
);

-- Test 5: private_get_access_log exists
select has_function(
    'deribit',
    'private_get_access_log',
    'private_get_access_log endpoint should exist'
);

-- Test 6: private_create_combo exists
select has_function(
    'deribit',
    'private_create_combo',
    'private_create_combo endpoint should exist'
);

select * from finish();
rollback;
