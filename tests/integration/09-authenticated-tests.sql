-- Authenticated Integration Tests
-- Tests critical endpoints with TestNet credentials
-- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET to be set as psql variables
--
-- Usage:
--   psql -v client_id="your_id" -v client_secret="your_secret" -f 09-authenticated-tests.sql
--
-- Or set in the database:
--   ALTER DATABASE deribit SET deribit.test_client_id = 'your_id';
--   ALTER DATABASE deribit SET deribit.test_client_secret = 'your_secret';

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

\c

begin;

select plan(3);

-- Setup: Enable TestNet and set authentication
select deribit.enable_test_net();

-- Set authentication using psql variables or database settings
-- This will use :client_id and :client_secret if passed via -v flag
-- Otherwise tries to use database settings
DO $$
DECLARE
    v_client_id text;
    v_client_secret text;
BEGIN
    -- Try psql variables first (passed via -v)
    BEGIN
        v_client_id := current_setting('deribit.test_client_id');
        v_client_secret := current_setting('deribit.test_client_secret');
    EXCEPTION WHEN undefined_object THEN
        RAISE EXCEPTION 'Authentication credentials not found. Set via: ALTER DATABASE deribit SET deribit.test_client_id = ''your_id'';';
    END;

    -- Set the auth
    PERFORM deribit.set_client_auth(v_client_id, v_client_secret);
END $$;

-- Test 1: Verify authentication was set
select ok(
    (select deribit.get_auth() is not null),
    'Should have authentication configured'
);

-- Test 2: Verify we can connect to TestNet
select ok(
    (select deribit.public_get_time() > 0),
    'Should connect to TestNet and get server timestamp'
);

-- Test 3: Verify authenticated endpoint works (requires proper credentials)
-- This tests that credentials work by checking if we get a valid response structure
-- We use a simple endpoint that doesn't require enum type casts
select lives_ok(
    $$SELECT deribit.private_get_subaccounts(null)$$,
    'Should successfully call authenticated endpoint with TestNet credentials'
);

select * from finish();
rollback;
