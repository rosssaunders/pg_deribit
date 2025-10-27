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

-- Test 1: public_test returns API version
select ok(
    (select (public_test).version from deribit.public_test()) is not null,
    'public_test should return API version'
);

-- Test 2: public_get_time returns timestamp
select ok(
    (select deribit.public_get_time() > 0),
    'public_get_time should return a valid timestamp'
);

-- Test 3: public_get_currencies returns data
select ok(
    (select count(*) from deribit.public_get_currencies()) > 0,
    'public_get_currencies should return at least one currency'
);

-- Test 4: public_get_currencies returns BTC
select ok(
    (select count(*) from deribit.public_get_currencies() where currency = 'BTC') = 1,
    'public_get_currencies should return BTC'
);

-- Test 5: public_status endpoint works
select ok(
    (select deribit.public_status() is not null),
    'public_status should return data'
);

select * from finish();
rollback;
