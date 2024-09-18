create extension if not exists pg_deribit cascade;

select deribit.store_auth(
    client_id := 'rvAcPbEz',
    client_secret := 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE');
select deribit.get_auth();

select *
from deribit.private_list_api_keys(
    auth := (select deribit.get_auth())
);

select *
from deribit.private_create_api_key(
    auth := (select deribit.get_auth()),
    name := 'new_key',
    max_scope := ''
);

select *
from deribit.private_disable_api_key(
    auth := (select deribit.get_auth()),
    id := 6
);

select *
from deribit.private_enable_api_key(
    auth := (select deribit.get_auth()),
    id := 6
);

select *
from deribit.private_reset_api_key(
    auth := (select deribit.get_auth()),
    id := 6
);

select *
from deribit.private_edit_api_key(
    auth := (select deribit.get_auth()),
    id := 2,
    max_scope := 'trade:[read_write]'
);

select *
from deribit.private_change_api_key_name(
    auth := (select deribit.get_auth()),
    id := 2,
    name := 'new_key_name'
);

select *
from deribit.private_change_scope_in_api_key(
    auth := (select deribit.get_auth()),
    id := 2,
    max_scope := 'trade:[read_write], wallet:[read_write], account:[read_write], block_trade:[read_write]'
);

select *
from deribit.private_remove_api_key(
    auth := (select deribit.get_auth()),
    id := 6
);
