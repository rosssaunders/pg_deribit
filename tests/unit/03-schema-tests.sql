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

select plan(5);

-- Test 1: Verify deribit schema exists
select has_schema('deribit', 'deribit schema should exist');

-- Test 2: Verify auth type exists
select has_type('deribit', 'auth', 'auth type should exist');

-- Test 3: Verify internal_error type exists
select has_type('deribit', 'internal_error', 'internal_error type should exist');

-- Test 4: Verify call log table exists
select has_table(
    'deribit',
    'matching_engine_request_call_log',
    'matching_engine_request_call_log table should exist'
);

-- Test 5: Verify endpoint rate limit table exists
select has_table(
    'deribit',
    'internal_endpoint_rate_limit',
    'internal_endpoint_rate_limit table should exist'
);

select * from finish();
rollback;
