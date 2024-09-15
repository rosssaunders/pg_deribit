create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_buy(
    (select row('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE')::deribit.auth),
    instrument_name := 'BTC-PERPETUAL',
    contracts := 1,
    type := 'limit',
    price := 60000
);

select *
from deribit.private_sell(
    instrument_name := 'BTC-PERPETUAL',
    contracts := 1,
    type := 'limit',
    price := 60000
);

select *
from deribit.private_edit(
    order_id := '123456',
    contracts := 1,
    price := 60000
);

select *
from deribit.private_edit_by_label(
    label := 'label',
    instrument_name := 'BTC-PERPETUAL',
    contracts := 1,
    price := 60000
);

select *
from deribit.private_cancel(
    order_id := '123456'
);

-- todo: this doesn't work
select *
from deribit.private_cancel_all(
    detailed := true,
    freeze_quotes := false
);

select *
from deribit.private_cancel_all_by_currency(
    currency := 'BTC'
);

select *
from deribit.private_cancel_all_by_currency_pair(
    currency_pair := 'btc_usd'
);

select *
from deribit.private_cancel_all_by_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

select *
from deribit.private_cancel_all_by_kind_or_type(
    currency := array['BTC'],
    kind := 'future',
    type := 'limit'
);

select *
from deribit.private_cancel_by_label(
    label := '123'
);

-- todo: this doesn't work
select *
from deribit.private_cancel_quotes(
    detailed := true,
    cancel_type := 'all',
    currency := 'BTC',
    currency_pair := 'btc_usd'
);

select *
from deribit.private_close_position(
    instrument_name := 'BTC-PERPETUAL',
    type := 'market'
);

select *
from deribit.private_get_margins(
    instrument_name := 'BTC-PERPETUAL',
    amount := 10,
    price := 60000
);

select *
from deribit.private_get_open_orders();

select *
from deribit.private_get_open_orders_by_currency(
    currency := 'BTC'
);

select *
from deribit.private_get_open_orders_by_instrument(
    instrument_name := 'BTC-PERPETUAL',
    type := 'limit'
);

select *
from deribit.private_get_open_orders_by_label(
    currency := 'BTC',
    label := 'label'
);

select *
from deribit.private_get_order_history_by_currency(
    currency := 'BTC'
);

select *
from deribit.private_get_order_history_by_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

select *
from deribit.private_get_order_margin_by_ids(
    ids := array['123']
);

select *
from deribit.private_get_order_state(
    order_id := '123'
);

select *
from deribit.private_get_order_state_by_label(
    currency := 'BTC',
    label := '123'
);

select *
from deribit.private_get_trigger_order_history(
    currency := 'BTC'
);

select *
from deribit.private_get_user_trades_by_currency(
    currency := 'BTC'
);

select *
from deribit.private_get_user_trades_by_currency_and_time(
    currency := 'BTC',
    start_timestamp := (extract(epoch from '2024-09-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-15'::timestamptz) * 1000)::bigint
);


select *
from deribit.private_get_user_trades_by_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

select *
from deribit.private_get_user_trades_by_instrument_and_time(
    instrument_name := 'BTC-PERPETUAL',
    start_timestamp := (extract(epoch from '2024-09-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-15'::timestamptz) * 1000)::bigint
);

select *
from deribit.private_get_user_trades_by_order(
    order_id := '123'
);

select *
from deribit.private_send_rfq(
    instrument_name := 'BTC-PERPETUAL',
    amount := 10000,
    side := 'buy'
);

select *
from deribit.private_get_settlement_history_by_currency(
    currency := 'BTC'
);

select *
from deribit.private_get_settlement_history_by_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

