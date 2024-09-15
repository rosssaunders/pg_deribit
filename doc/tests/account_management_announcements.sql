create extension if not exists pg_deribit cascade;

delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.public_get_announcements();

select *
from deribit.private_get_new_announcements();

select *
from deribit.private_set_announcement_as_read(
    announcement_id := 1719588229230
);

