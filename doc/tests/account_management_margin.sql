create extension if not exists pg_deribit cascade;

delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_change_margin_model(
    margin_model := 'cross_pm',
    dry_run := true
);

-- TODO
select *
from deribit.private_pme_simulate(
    currency := 'CROSS'
);

-- TODO: doesn't work
select *
from deribit.private_simulate_portfolio(
    currency := 'BTC'
);

select *
from deribit.private_toggle_portfolio_margining(
    enabled := true
);
