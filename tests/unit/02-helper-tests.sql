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

select plan(3);

-- Test 1: Verify unnest_2d_1d function exists
select has_function(
    'deribit',
    'unnest_2d_1d',
    'unnest_2d_1d function should exist'
);

-- Test 2: Test unnest_2d_1d with sample data
select is(
    (select count(*) from deribit.unnest_2d_1d(array[[1,2],[3,4]]::numeric[][])),
    2::bigint,
    'unnest_2d_1d should return 2 rows for 2x2 array'
);

-- Test 3: Test unnest_2d_1d returns correct structure
select ok(
    (select array_length(unnest_2d_1d, 1) = 2 from deribit.unnest_2d_1d(array[[1,2],[3,4]]::numeric[][]) limit 1),
    'unnest_2d_1d should return arrays of length 2'
);

select * from finish();
rollback;
