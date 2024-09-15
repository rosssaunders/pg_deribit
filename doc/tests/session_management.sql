create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_get_cancel_on_disconnect(
    scope := 'account'
);

select *
from deribit.private_enable_cancel_on_disconnect(
    scope := 'account'
);

select *
from deribit.private_disable_cancel_on_disconnect(
    scope := 'account'
);
