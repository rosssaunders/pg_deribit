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

select plan(2);

-- Test 1: private_send_rfq should not exist (deprecated by Deribit)
select hasnt_function(
    'deribit',
    'private_send_rfq',
    'private_send_rfq should be removed (deprecated)'
);

-- Test 2: public_get_rfqs should not exist (deprecated by Deribit)
select hasnt_function(
    'deribit',
    'public_get_rfqs',
    'public_get_rfqs should be removed (deprecated)'
);

select * from finish();
rollback;
