# pg_deribit - Deribit API Wrapper for PostgreSQL

This project provides a PostgreSQL wrapper for the Deribit API, enabling easy interaction with Deribit's cryptocurrency trading platform from PostgreSQL.

It's designed for developers and data analysts who want to integrate Deribit's features into PostgreSQL-based applications or perform complex data analysis.

## Who is this for

![Who is this for](whoisthisfor.png)

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/)
- [Deribit account](https://www.deribit.com/) (Production or Testnet)
- [psql](https://www.postgresql.org/docs/current/app-psql.html)

## Quickstart

Run the following commands to start a fresh container using the pre-built image:

```bash
# stop and remove any existing container called pg_deribit
docker stop pg_deribit 2>/dev/null || true
docker rm -f pg_deribit 2>/dev/null || true

# pull and run the latest image from GitHub Container Registry
docker run -d --name pg_deribit -p 5433:5432 \
  -e POSTGRES_PASSWORD=deribitpwd \
  -e POSTGRES_USER=deribit \
  -e POSTGRES_DB=deribit \
  ghcr.io/rosssaunders/pg_deribit:latest

# connect to the container
PGPASSWORD=deribitpwd psql -h localhost -p 5433 -U deribit -d deribit

# load the extension
create extension if not exists pg_deribit cascade;

# test the extension
select currency
from deribit.public_get_currencies()
order by currency;

# exit the container
\q
```

Connect using your favourite Postgres GUI and get going. For how to use it, see the examples in the doc folder.

## Building from Source

If you want to build the Docker image from source (for development or customization):

```bash
# clone the repository
git clone https://github.com/rosssaunders/pg_deribit
cd pg_deribit

# build the Docker image
docker build . -t pg_deribit

# run the container
docker run -d --name pg_deribit -p 5433:5432 \
  -e POSTGRES_PASSWORD=deribitpwd \
  -e POSTGRES_USER=deribit \
  -e POSTGRES_DB=deribit \
  pg_deribit

# connect to the container
PGPASSWORD=deribitpwd psql -h localhost -p 5433 -U deribit -d deribit
```

## Usage

### Authentication

pg_deribit supports two methods for authentication:

#### 1. Session Variables (Default)

```sql
-- Set credentials for the current session
select deribit.set_client_auth('<CLIENT_ID>', '<CLIENT_SECRET>');
```

#### 2. Omnigres Credentials (Recommended for Production)

If you have the `omni_credentials` extension installed, you can store credentials securely:

```sql
-- Install omni_credentials extension
create extension if not exists omni_credentials;

-- Store your Deribit credentials ONCE
select deribit.store_credentials(
    client_id := '<CLIENT_ID>',
    client_secret := '<CLIENT_SECRET>',
    credential_name := 'deribit'  -- optional, defaults to 'deribit'
);

-- Credentials are now automatically retrieved for all API calls in ANY session
-- No need to set them again!
```

**How it works:**
- Credentials are stored in the `omni_credentials.credentials` table (persistent, encrypted)
- When you call any Deribit API function, `get_auth()` is automatically invoked
- `get_auth()` queries the database table to retrieve credentials on-demand
- No session variables are set - credentials are fetched fresh from the database each time
- Session variables still take priority if set (for backwards compatibility)

For more details on `omni_credentials`, see the [Omnigres documentation](https://docs.omnigres.org/omni_credentials/credentials/).

Refer to the docs folder for examples and the sql/endpoints folder for the full list of endpoints.

## Contributing

Contributions are welcome! Please read our contributing guidelines in CONTRIBUTING.md before submitting pull requests.
