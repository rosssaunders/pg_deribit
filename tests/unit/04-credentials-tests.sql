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

select plan(14);

-- Test 1: Verify has_omni_credentials function exists
select has_function(
    'deribit',
    'has_omni_credentials',
    array[]::text[],
    'has_omni_credentials function should exist'
);

-- Test 2: Verify has_omni_credentials returns false when extension not installed
select is(
    deribit.has_omni_credentials(),
    false,
    'has_omni_credentials should return false when omni_credentials is not installed'
);

-- Test 3: Verify store_credentials function exists
select has_function(
    'deribit',
    'store_credentials',
    array['text', 'text', 'text', 'text', 'text'],
    'store_credentials function should exist'
);

-- Test 4: Verify get_credentials_from_store function exists
select has_function(
    'deribit',
    'get_credentials_from_store',
    array['text'],
    'get_credentials_from_store function should exist'
);

-- Test 5: Verify get_auth now accepts credential_name parameter
select has_function(
    'deribit',
    'get_auth',
    array['text'],
    'get_auth should accept credential_name parameter'
);

-- Test 6: Verify store_credentials raises error when omni_credentials not available
select throws_ok(
    $$select deribit.store_credentials('test_id', 'test_secret')$$,
    'omni_credentials extension is not installed. Install it first with: CREATE EXTENSION omni_credentials;',
    'store_credentials should raise error when omni_credentials is not installed'
);

-- Test 7: Verify get_credentials_from_store returns null when omni_credentials not available
select is(
    deribit.get_credentials_from_store('deribit'),
    null::deribit.auth,
    'get_credentials_from_store should return null when omni_credentials is not installed'
);

-- Test 8: Verify backwards compatibility - get_auth with session variables
select lives_ok(
    $$select deribit.set_client_auth('test_client', 'test_secret')$$,
    'Should still be able to set credentials via session variables'
);

-- Test 9: Verify get_auth retrieves session variable credentials
select is(
    (deribit.get_auth()).client_id,
    'test_client',
    'get_auth should retrieve client_id from session variables'
);

-- Test 10: Verify get_auth retrieves client_secret from session variables
select is(
    (deribit.get_auth()).client_secret,
    'test_secret',
    'get_auth should retrieve client_secret from session variables'
);

-- Test 11: Test set_access_token_auth function
select lives_ok(
    $$select deribit.set_access_token_auth('access123', 'refresh123')$$,
    'Should be able to set access token auth'
);

-- Test 12: Verify get_auth retrieves access token
select is(
    (deribit.get_auth()).access_token,
    'access123',
    'get_auth should retrieve access_token from session variables'
);

-- Test 13: Verify get_auth retrieves refresh token
select is(
    (deribit.get_auth()).refresh_token,
    'refresh123',
    'get_auth should retrieve refresh_token from session variables'
);

-- Test 14: Test get_auth with default parameter works
select lives_ok(
    $$select deribit.get_auth()$$,
    'get_auth should work without parameters (default credential_name)'
);

select * from finish();
rollback;
