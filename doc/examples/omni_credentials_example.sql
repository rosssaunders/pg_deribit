------------------------------------------------------------------------
-- Example: Using Omnigres Credentials for Secure Credential Storage
------------------------------------------------------------------------

-- This example demonstrates how to use omni_credentials extension
-- to securely store and manage Deribit API credentials

------------------------------------------------------------------------
-- SETUP: Install Extensions
------------------------------------------------------------------------

-- Install pg_deribit extension (this will also load required dependencies)
create extension if not exists pg_deribit cascade;

-- Install omni_credentials extension for secure credential storage
-- Note: This is optional - if not available, you can still use session variables
create extension if not exists omni_credentials;

------------------------------------------------------------------------
-- Method 1: Using omni_credentials (Recommended for Production)
------------------------------------------------------------------------

-- Store your Deribit credentials securely
-- These credentials will persist across sessions and are encrypted
select deribit.store_credentials(
    client_id := 'YOUR_CLIENT_ID_HERE',
    client_secret := 'YOUR_CLIENT_SECRET_HERE',
    credential_name := 'deribit'  -- optional, defaults to 'deribit'
);

-- HOW IT WORKS:
-- 1. Credentials are saved to omni_credentials.credentials table (database table)
-- 2. When you call any API function, deribit.get_auth() is invoked automatically
-- 3. get_auth() queries the credentials table to fetch your credentials
-- 4. No session variables are set - credentials retrieved fresh each time
-- 5. Works in any session automatically - no setup needed!

-- That's it! Now all API calls will automatically use these credentials
-- No need to set credentials in each session

-- Example: Get currencies using stored credentials
select currency, currency_long, coin_type
from deribit.public_get_currencies()
order by currency
limit 5;

------------------------------------------------------------------------
-- Method 2: Using Session Variables (Quick Start / Development)
------------------------------------------------------------------------

-- If omni_credentials is not available, or for quick testing,
-- you can use session variables (must be set in each session)
select deribit.set_client_auth('YOUR_CLIENT_ID_HERE', 'YOUR_CLIENT_SECRET_HERE');

-- Example: Get currencies using session credentials
select currency, currency_long, coin_type
from deribit.public_get_currencies()
order by currency
limit 5;

------------------------------------------------------------------------
-- Advanced: Managing Multiple Credential Sets
------------------------------------------------------------------------

-- You can store different credentials for different environments

-- Production credentials
select deribit.store_credentials(
    client_id := 'PROD_CLIENT_ID',
    client_secret := 'PROD_CLIENT_SECRET',
    credential_name := 'deribit_production'
);

-- TestNet credentials
select deribit.store_credentials(
    client_id := 'TEST_CLIENT_ID',
    client_secret := 'TEST_CLIENT_SECRET',
    credential_name := 'deribit_testnet'
);

-- Switch to TestNet mode
select deribit.enable_test_net();

-- The extension will automatically use 'deribit' credentials by default
-- You can access different credential sets by passing credential_name if needed

------------------------------------------------------------------------
-- Checking Credential Status
------------------------------------------------------------------------

-- Check if omni_credentials extension is available
select deribit.has_omni_credentials();

-- Get current auth (shows what credentials are being used)
-- Note: For security, this only shows if credentials exist, not the actual values
select 
    case when (deribit.get_auth()).client_id is not null then 'Client ID set' else 'No client ID' end as client_id_status,
    case when (deribit.get_auth()).client_secret is not null then 'Client Secret set' else 'No client secret' end as client_secret_status,
    case when (deribit.get_auth()).access_token is not null then 'Access Token set' else 'No access token' end as access_token_status;

------------------------------------------------------------------------
-- Updating Stored Credentials
------------------------------------------------------------------------

-- To update credentials, simply call store_credentials again
-- This will replace the existing credentials
select deribit.store_credentials(
    client_id := 'NEW_CLIENT_ID',
    client_secret := 'NEW_CLIENT_SECRET',
    credential_name := 'deribit'
);

------------------------------------------------------------------------
-- Benefits of Using omni_credentials
------------------------------------------------------------------------

-- 1. Persistence: Credentials stored once, available in all sessions
-- 2. Security: Credentials are encrypted at rest
-- 3. Access Control: Role-based access via PostgreSQL's security model
-- 4. Centralized: Manage all credentials from one place
-- 5. No Code Changes: Application code doesn't need to handle credentials

------------------------------------------------------------------------
-- Migration from Session Variables to omni_credentials
------------------------------------------------------------------------

-- If you're currently using session variables, migration is easy:
-- 1. Install omni_credentials extension
-- 2. Call store_credentials() once with your credentials
-- 3. Remove set_client_auth() calls from your code
-- 4. Everything else remains the same!

-- Your existing code will continue to work without modifications
