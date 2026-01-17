-- Setup integration test environment

-- Load extensions outside transaction
create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

-- Clear invalidation messages
\c

begin;
select plan(1);

-- Verify we can access public API (no auth required)
select ok(
    (select deribit.public_test() is not null),
    'Should be able to call public_test endpoint'
);

select * from finish();
rollback;


