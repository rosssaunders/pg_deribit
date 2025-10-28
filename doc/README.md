# Installing

```sql
create extension if not exists pg_deribit cascade;
```

## Authentication Methods

### Method 1: Session Variables (Quick Start)

Set credentials for the current session:

```sql
select deribit.set_client_auth('<CLIENT_ID>', '<CLIENT_SECRET>');
```

This method is simple but requires setting credentials in every new session.

### Method 2: Omnigres Credentials (Recommended for Production)

For persistent, secure credential storage, use `omni_credentials`:

```sql
-- First, install omni_credentials extension (if not already installed)
create extension if not exists omni_credentials;

-- Store your Deribit credentials securely ONCE
select deribit.store_credentials(
    client_id := '<CLIENT_ID>',
    client_secret := '<CLIENT_SECRET>',
    credential_name := 'deribit'  -- optional, defaults to 'deribit'
);
```

**How it works:**
1. `store_credentials()` saves your credentials to the `omni_credentials.credentials` table (persistent database table)
2. When you call any Deribit API function (e.g., `public_get_currencies()`), it internally calls `get_auth()`
3. `get_auth()` queries the `omni_credentials.credentials` table to retrieve your credentials
4. Credentials are fetched from the database on-demand - no session variables are set
5. This happens transparently in every session without any setup

**Benefits of using omni_credentials:**
- Credentials persist across sessions (stored in database, not session memory)
- Encrypted storage (handled by omni_credentials extension)
- Role-based access control (PostgreSQL's built-in security)
- No need to embed secrets in application code
- Centralized credential management

**Multiple Environments:**

You can store different credentials for different purposes:

```sql
-- Production credentials
select deribit.store_credentials(
    client_id := '<PROD_CLIENT_ID>',
    client_secret := '<PROD_CLIENT_SECRET>',
    credential_name := 'deribit_production'
);

-- TestNet credentials
select deribit.store_credentials(
    client_id := '<TEST_CLIENT_ID>',
    client_secret := '<TEST_CLIENT_SECRET>',
    credential_name := 'deribit_testnet'
);

-- Use specific credentials by passing the credential_name to get_auth()
-- (This is handled automatically by the extension, but you can specify it if needed)
```

For more information on `omni_credentials`, see the [Omnigres documentation](https://docs.omnigres.org/omni_credentials/credentials/).

## Switch between the Production and TestNet servers

```sql
select deribit.enable_test_net();
select deribit.disable_test_net();
```

## Examples

Then see the examples in the `examples` folder.
