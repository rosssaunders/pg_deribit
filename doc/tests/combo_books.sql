create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

-- COMBOS
select *
from deribit.public_get_combos(
    currency := 'BTC'
);

select *
from deribit.public_get_combo_ids(
    currency := 'BTC',
    state := 'active'
) x;

select *
from deribit.public_get_combo_details(
    combo_id := 'BTC-FS-25OCT24_20SEP24'
);
