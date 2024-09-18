create extension if not exists pg_deribit cascade;

select *
from deribit.public_get_announcements();

select deribit.store_auth(
    client_id := 'rvAcPbEz',
    client_secret := 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE');
select deribit.get_auth();

select *
from deribit.private_get_new_announcements(
    auth := (select deribit.get_auth())
);

select *
from deribit.private_set_announcement_as_read(
    auth := (select deribit.get_auth()),
    announcement_id := 1719588229230
);

