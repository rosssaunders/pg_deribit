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

-- Test 1: Verify set_client_auth function exists
select has_function(
    'deribit',
    'set_client_auth',
    array['text', 'text'],
    'set_client_auth function should exist'
);

-- Test 2: Set client auth and verify it's stored
select lives_ok(
    $$select deribit.set_client_auth('test_client_id', 'test_client_secret')$$,
    'Should be able to set client authentication'
);

-- Test 3: Verify client_id is stored via omni_var
select is(
    omni_var.get('deribit', 'client_id'),
    'test_client_id',
    'Client ID should be stored in omni_var'
);

-- Test 4: Verify client_secret is stored via omni_var
select is(
    omni_var.get('deribit', 'client_secret'),
    'test_client_secret',
    'Client secret should be stored in omni_var'
);

-- Test 5: Test enable_test_net function
select lives_ok(
    $$select deribit.enable_test_net()$$,
    'Should be able to enable TestNet'
);

-- Test 6: Test disable_test_net function
select lives_ok(
    $$select deribit.disable_test_net()$$,
    'Should be able to disable TestNet'
);

select * from finish();
rollback;
