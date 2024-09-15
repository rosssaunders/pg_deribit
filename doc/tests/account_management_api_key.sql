create extension if not exists pg_deribit cascade;

delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_list_api_keys();

select *
from deribit.private_create_api_key(
    name := 'new_key',
    max_scope := ''
);

select *
from deribit.private_disable_api_key(
    id := 2
);

select *
from deribit.private_enable_api_key(
    id := 2
);

select *
from deribit.private_remove_api_key(
    id := 2
);

select *
from deribit.private_reset_api_key(
    id := 2
);

select *
from deribit.private_edit_api_key(
    id := 2,
    max_scope := 'trade:[read_write]'
);

select *
from deribit.private_change_api_key_name(
    id := 2,
    name := 'new_key_name'
);

select *
from deribit.private_change_scope_in_api_key(
    id := 2,
    max_scope := 'trade:[read_write], wallet:[read_write], account:[read_write], block_trade:[read_write]'
);

