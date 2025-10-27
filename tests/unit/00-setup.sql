-- Setup test environment
-- This file should run first to ensure pgTAP is available

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

select plan(1);

-- Verify extension is loaded
select has_extension('pg_deribit', 'pg_deribit extension should be installed');

select * from finish();
rollback;
