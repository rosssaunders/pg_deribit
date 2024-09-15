create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_cancel_transfer_by_id(
    currency := 'BTC',
    id := '123'
);

select *
from deribit.private_cancel_withdrawal(
    currency := 'BTC',
    id := '123'
);

select *
from deribit.private_create_deposit_address(
    currency := 'BTC'
);

select *
from deribit.private_get_current_deposit_address(
    currency := 'BTC'
);

select *
from deribit.private_get_deposits(
    currency := 'BTC'
);

select *
from deribit.private_get_transfers(
    currency := 'BTC'
);

select *
from deribit.private_get_withdrawals(
    currency := 'BTC'
);

select *
from deribit.private_submit_transfer_between_subaccounts(
    currency := 'BTC',
    amount := 1.0,
    source := 35195::bigint,
    destination := 54584::bigint
);

select *
from deribit.private_submit_transfer_to_subaccount(
    currency := 'BTC',
    amount := 1.0,
    destination := 54584::bigint
);

select *
from deribit.private_submit_transfer_to_user(
    currency := 'BTC',
    amount := 1.0,
    destination := 'sdafsdfdsf'
);

select *
from deribit.private_withdraw(
    currency := 'BTC',
    address := '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
    amount := 1.0
);
