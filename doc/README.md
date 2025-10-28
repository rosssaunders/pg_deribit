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

-- Store your Deribit credentials securely
select deribit.store_credentials(
    client_id := '<CLIENT_ID>',
    client_secret := '<CLIENT_SECRET>',
    credential_name := 'deribit'  -- optional, defaults to 'deribit'
);
```

**Benefits of using omni_credentials:**
- Credentials persist across sessions
- Encrypted storage
- Role-based access control
- No need to embed secrets in application code
- Centralized credential management

The extension automatically retrieves credentials from `omni_credentials` when available, so you don't need to call `set_client_auth()` in each session.

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
