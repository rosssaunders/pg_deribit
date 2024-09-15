create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_get_mmp_config();

select *
from deribit.private_reset_mmp(
    index_name := 'btc_usd'
);

-- todo: this doesn't work
select *
from deribit.private_set_mmp_config(
    index_name := 'btc_usd',
    interval := 0::bigint,
    frozen_time := 0::bigint
);
