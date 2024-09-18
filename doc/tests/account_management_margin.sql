create extension if not exists pg_deribit cascade;

select deribit.store_auth(
    client_id := 'rvAcPbEz',
    client_secret := 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE');
select deribit.get_auth();

select *
from deribit.private_change_margin_model(
    auth := deribit.get_auth(),
    margin_model := 'cross_pm',
    dry_run := true
);

-- TODO - returns zero columns
select *
from deribit.private_pme_simulate(
    auth := deribit.get_auth(),
    currency := 'CROSS'
);

-- TODO: doesn't work
select *
from deribit.private_simulate_portfolio(
    auth := deribit.get_auth(),
    currency := 'BTC'
);

select *
from deribit.private_toggle_portfolio_margining(
    auth := deribit.get_auth(),
    enabled := true
);
