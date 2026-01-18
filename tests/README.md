# pg_deribit Testing

This directory contains both SQL (pgTAP) and Python (pytest) tests for the pg_deribit PostgreSQL extension.

## Test Overview

### SQL Tests (This Directory)

pgTAP tests for the PostgreSQL extension - verifying endpoint functions exist and work correctly.

- **Total**: 112 tests across 14 files
- **Unit tests**: 20 tests (extension, auth, helpers, schema)
- **Integration tests**: 77 tests (endpoint verification, function existence)
- **Authenticated tests**: TestNet with real API calls (includes trading flow)
- **Coverage**: 100% of endpoint functions verified

### Python Tests (Code Generator)

Located in `../codegen/tests/` - pytest tests for the Python code generator.

- **Total**: 128 tests
- **Coverage**: 78% overall, 90%+ for core modules
- See `../codegen/README.md` for Python test details

## pgTAP Test Structure

- **unit/**: Fast, isolated tests that don't require external API access

  - `00-setup.sql` - Extension loading (1 test)
  - `01-auth-tests.sql` - Authentication (6 tests)
  - `02-helper-tests.sql` - Helper functions (3 tests)
  - `03-schema-tests.sql` - Schema verification (5 tests)

- **integration/**: Tests that verify endpoint functions and API connectivity
  - `00-setup.sql` - Integration setup (1 test)
  - `01-public-api-tests.sql` - Public API (5 tests)
  - `02-new-endpoints-tests.sql` - New endpoints (8 tests)
  - `03-removed-endpoints-tests.sql` - Removed endpoints (2 tests)
  - `04-order-endpoints-tests.sql` - Order management (15 tests)
  - `05-account-endpoints-tests.sql` - Account management (12 tests)
  - `06-api-key-endpoints-tests.sql` - API key management (6 tests)
  - `07-block-trade-endpoints-tests.sql` - Block trades (4 tests)
  - `08-public-endpoints-tests.sql` - Public endpoints (10 tests)
  - `09-authenticated-tests.sql` - **Authenticated TestNet tests (15 tests)** 🆕
  - `13-authenticated-trading-flow-tests.sql` - **Authenticated trading flow (real buy/sell)** 🆕

## Running Tests

### Prerequisites

- PostgreSQL with pg_deribit extension installed
- pgTAP extension installed
- Connection to a PostgreSQL instance

### Local Testing

```bash
# Run all tests
make test

# Run only unit tests
make test-unit

# Run only integration tests
make test-integration

# Or use the test runner directly
cd tests
./run-tests.sh              # All tests
./run-tests.sh unit         # Unit only
./run-tests.sh integration  # Integration only
```

### Docker Testing

```bash
# Build and run in Docker
docker build -t pg_deribit:test .
docker run -d --name pg_deribit_test \
  -e POSTGRES_PASSWORD=deribitpwd \
  -e POSTGRES_USER=deribit \
  -e POSTGRES_DB=deribit \
  pg_deribit:test

# Wait for PostgreSQL
until docker exec pg_deribit_test pg_isready; do sleep 1; done
sleep 5

# Copy tests and run
docker cp tests pg_deribit_test:/tmp/tests
docker exec pg_deribit_test bash -c \
  "cd /tmp/tests && POSTGRES_PASSWORD=deribitpwd ./run-tests.sh"

# Cleanup
docker rm -f pg_deribit_test
```

## Writing New Tests

### Test File Template

```sql
-- Description of what this test file covers
begin;

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

select plan(N);  -- N = number of tests

-- Test 1
select has_function(
    'deribit',
    'function_name',
    array['arg_type'],
    'Description of what this tests'
);

-- Test 2
select ok(
    (select condition),
    'Description of expected behavior'
);

-- More tests...

select * from finish();
rollback;
```

### pgTAP Assertion Functions

Common assertions used in tests:

- `has_schema(schema)` - Check if schema exists
- `has_table(schema, table)` - Check if table exists
- `has_function(schema, func, args)` - Check if function exists
- `has_type(schema, type)` - Check if type exists
- `ok(boolean, description)` - Assert true
- `is(actual, expected, description)` - Assert equality
- `isnt(actual, unexpected, description)` - Assert inequality
- `lives_ok(sql, description)` - Assert SQL executes without error
- `throws_ok(sql, description)` - Assert SQL throws error

See [pgTAP documentation](https://pgtap.org/) for more.

## CI/CD

Tests run automatically via GitHub Actions on:

- Pull requests
- Pushes to main
- Manual workflow dispatch

See `.github/workflows/test.yml` for the CI configuration.

## Test Strategy

**Level 1: Function Existence** (All tests)

- Verifies each endpoint function exists with correct signature
- Uses `has_function()` and `hasnt_function()` pgTAP assertions
- Fast: <1 second per file
- No authentication required

**Level 2: Basic Response** (Public endpoint tests)

- Calls public endpoints and validates responses
- Tests `public_get_instruments()` and `public_get_time()`
- Requires network access to Deribit API
- No authentication required

**Level 3: Authenticated Integration** (15 tests) 🆕

- Uses TestNet credentials from environment variables
- Tests critical read-only endpoints:
  - Authentication (`public_auth`)
  - Account data (`private_get_account_summary`)
  - Positions (`private_get_positions`)
  - Order history (`private_get_order_history_by_currency`)
  - Trade history (`private_get_user_trades_by_currency`)
  - Deposits/Withdrawals/Transfers
  - Address book, subaccounts, API keys
- No side effects (read-only operations)
- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET environment variables

**Level 4: Full E2E** (Trading flow)

- Executes a buy -> position -> sell flow on TestNet
- Uses `13-authenticated-trading-flow-tests.sql` with a dedicated account

## Manual Testing Examples

**Connect to database:**

```bash
PGPASSWORD=deribitpwd psql -h localhost -p 5433 -U deribit -d deribit
```

**Load extension:**

```sql
CREATE EXTENSION IF NOT EXISTS pg_deribit CASCADE;
```

**Test endpoint exists:**

```sql
\df deribit.private_get_reward_eligibility
```

**Test live public endpoint:**

```sql
SELECT * FROM deribit.public_test();
SELECT * FROM deribit.public_get_currencies() ORDER BY currency LIMIT 5;
```

**Run authenticated tests with TestNet credentials:**

```bash
# Set credentials
export DERIBIT_CLIENT_ID="your-testnet-client-id"
export DERIBIT_CLIENT_SECRET="your-testnet-client-secret"

# Configure PostgreSQL database
PGPASSWORD=deribitpwd psql -h localhost -p 5433 -U deribit -d deribit <<EOF
ALTER DATABASE deribit SET deribit.test_client_id = '$DERIBIT_CLIENT_ID';
ALTER DATABASE deribit SET deribit.test_client_secret = '$DERIBIT_CLIENT_SECRET';
EOF

# Reconnect to pick up new settings, then run authenticated tests
PGPASSWORD=deribitpwd psql -h localhost -p 5433 -U deribit -d deribit \
  -f integration/09-authenticated-tests.sql
```

The `../doc/examples/` directory contains comprehensive manual testing scripts that demonstrate real-world usage patterns.
