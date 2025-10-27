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

select plan(2);

-- Setup: Enable TestNet and set authentication
select deribit.enable_test_net();

-- Set authentication using database settings (set by workflow)
DO $$
DECLARE
    v_client_id text;
    v_client_secret text;
BEGIN
    -- Get credentials from database settings (set by ALTER DATABASE in workflow)
    BEGIN
        v_client_id := current_setting('deribit.test_client_id');
        v_client_secret := current_setting('deribit.test_client_secret');
    EXCEPTION WHEN undefined_object THEN
        RAISE EXCEPTION 'Authentication credentials not found. Set via: ALTER DATABASE deribit SET deribit.test_client_id = ''your_id'';';
    END;

    -- Set the auth for this session
    PERFORM deribit.set_client_auth(v_client_id, v_client_secret);
END $$;

-- Test 1: Verify TestNet connectivity
select ok(
    (select deribit.public_get_time() > 0),
    'Should connect to TestNet and get server timestamp'
);

-- Test 2: Verify authenticated endpoint works with TestNet credentials
-- This confirms that authentication is working correctly
select lives_ok(
    $$SELECT deribit.private_get_subaccounts(null)$$,
    'Should successfully call authenticated endpoint with TestNet credentials'
);

select * from finish();
rollback;
