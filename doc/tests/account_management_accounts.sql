create extension if not exists pg_deribit cascade;

select deribit.store_auth(
    client_id := 'rvAcPbEz',
    client_secret := 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE');
select deribit.get_auth();

select *
from deribit.private_get_account_summaries(
    auth := (select deribit.get_auth()),
    extended := true
);

select *
from deribit.private_get_account_summary(
    auth := (select deribit.get_auth()),
    currency := 'BTC',
    extended := true
);

select *
from deribit.private_get_subaccounts(
    auth := (select deribit.get_auth())
);

select *
from deribit.private_get_user_locks(
    auth := (select deribit.get_auth())
);

select *
from deribit.private_get_subaccounts_details(
    auth := (select deribit.get_auth()),
    currency := 'BTC'
);

select *
from deribit.private_create_subaccount(
    auth := (select deribit.get_auth())
);

select deribit.private_change_subaccount_name(
    auth := (select deribit.get_auth()),
    name := 'new_name',
    sid := 60639
);

select deribit.private_remove_subaccount(
    auth := (select deribit.get_auth()),
    subaccount_id := 60639
);

select *
from deribit.private_list_custody_accounts(
    auth := (select deribit.get_auth()),
    currency := 'BTC'
);

select deribit.private_set_email_for_subaccount(
    auth := (select deribit.get_auth()),
    sid := 60640,
    email := 'test@outlook.com'
);

select deribit.private_set_disabled_trading_products(
    auth := (select deribit.get_auth()),
    user_id := 60640,
    trading_products := array['futures']
);

select deribit.private_toggle_notifications_from_subaccount(
    auth := (select deribit.get_auth()),
    sid := 60640,
    state := true
);

select deribit.private_toggle_subaccount_login(
    auth := (select deribit.get_auth()),
    sid := 60640,
    state := 'enable'
);
