-- Load pgtap first
create extension if not exists pgtap;

-- Reconnect to clear any invalidation messages
\c

-- Load pg_deribit outside transaction
create extension if not exists pg_deribit cascade;

-- Try to load omni_credentials (may not be available)
do $$
begin
    create extension if not exists omni_credentials;
exception when others then
    raise notice 'omni_credentials extension not available, skipping integration tests';
end;
$$;

-- Reconnect again to clear invalidation messages
\c

-- Only run tests if omni_credentials is available
do $$
declare
    _has_omni_creds boolean;
begin
    _has_omni_creds := exists(select 1 from pg_extension where extname = 'omni_credentials');
    
    if not _has_omni_creds then
        raise notice 'Skipping omni_credentials integration tests - extension not available';
        return;
    end if;

    -- Run the tests in a transaction
    begin
        perform plan(8);

        -- Test 1: Verify has_omni_credentials returns true
        perform is(
            deribit.has_omni_credentials(),
            true,
            'has_omni_credentials should return true when omni_credentials is installed'
        );

        -- Test 2: Store credentials successfully
        perform lives_ok(
            $$select deribit.store_credentials(
                client_id := 'test_client_123',
                client_secret := 'test_secret_456',
                credential_name := 'test_deribit'
            )$$,
            'Should be able to store credentials in omni_credentials'
        );

        -- Test 3: Retrieve credentials from store
        declare
            _auth deribit.auth;
        begin
            _auth := deribit.get_credentials_from_store('test_deribit');
            
            perform ok(
                _auth is not null,
                'get_credentials_from_store should return credentials'
            );
        end;

        -- Test 4: Verify stored client_id
        perform is(
            (deribit.get_credentials_from_store('test_deribit')).client_id,
            'test_client_123',
            'Retrieved client_id should match stored value'
        );

        -- Test 5: Verify stored client_secret
        perform is(
            (deribit.get_credentials_from_store('test_deribit')).client_secret,
            'test_secret_456',
            'Retrieved client_secret should match stored value'
        );

        -- Test 6: get_auth should retrieve from omni_credentials when session vars not set
        -- First clear any session variables
        perform set_config('deribit.client_id', null, false);
        perform set_config('deribit.client_secret', null, false);
        
        perform is(
            (deribit.get_auth('test_deribit')).client_id,
            'test_client_123',
            'get_auth should retrieve credentials from omni_credentials'
        );

        -- Test 7: Update credentials
        perform lives_ok(
            $$select deribit.store_credentials(
                client_id := 'updated_client_789',
                client_secret := 'updated_secret_012',
                credential_name := 'test_deribit'
            )$$,
            'Should be able to update stored credentials'
        );

        -- Test 8: Verify updated credentials
        perform is(
            (deribit.get_credentials_from_store('test_deribit')).client_id,
            'updated_client_789',
            'Retrieved client_id should match updated value'
        );

        perform finish();
    exception when others then
        -- Clean up on error
        perform finish();
        raise;
    end;
end;
$$;
