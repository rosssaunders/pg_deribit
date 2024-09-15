create extension if not exists pg_deribit cascade;

select deribit.public_get_announcements(
    start_timestamp := 1,
    count := 100
);

select *
from deribit.public_get_book_summary_by_currency(
    currency := 'BTC'
);

-- PERP
select *
from deribit.public_get_book_summary_by_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

-- FUTURE
select *
from deribit.public_get_book_summary_by_instrument(
    instrument_name := 'BTC-27SEP24'
);

-- OPTION
select *
from deribit.public_get_book_summary_by_instrument(
    instrument_name := 'BTC-27SEP24-65000-C'
);

select *
from deribit.public_get_contract_size(
    instrument_name := 'BTC-FS-25OCT24_20SEP24'
);

select *
from deribit.public_get_currencies();

select *
from deribit.public_get_delivery_prices('btc_usd');

select *
from deribit.public_get_funding_chart_data(
    instrument_name := 'BTC-PERPETUAL',
    length := '1m'
);

select *
from deribit.public_get_funding_rate_history(
    instrument_name := 'BTC-PERPETUAL',
    start_timestamp := (extract(epoch from '2024-09-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-15'::timestamptz) * 1000)::bigint
);

select *
from deribit.public_get_funding_rate_value(
    instrument_name := 'BTC-PERPETUAL',
    start_timestamp := (extract(epoch from '2024-09-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-15'::timestamptz) * 1000)::bigint
);

select deribit.public_get_historical_volatility(
    currency := 'BTC'
);

select *
from deribit.public_get_index_price(
    index_name := 'btc_usd'
);

select deribit.public_get_index_price_names();

select *
from deribit.public_get_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

select *
from deribit.public_get_instruments(
    currency := 'BTC',
    kind := 'future'
);

select *
from deribit.public_get_instruments(
    currency := 'BTC',
    kind := 'option'
);

select *
from deribit.public_get_last_settlements_by_currency(
    currency := 'BTC'
);

select *
from deribit.public_get_last_settlements_by_instrument(
    instrument_name := 'BTC-PERPETUAL',
    continuation := '23nYDkVbT3R4pk14ySCoKFo5MjgH7Sj5hJdNenSZy4VzFDynP8Vqu2ffngTu9ZBfzuVke'
);

select *
from deribit.public_get_last_trades_by_currency(
    currency := 'BTC'
);

select *
from deribit.public_get_last_trades_by_currency_and_time(
    currency := 'BTC',
    start_timestamp := (extract(epoch from '2024-09-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-15'::timestamptz) * 1000)::bigint
);

select *
from deribit.public_get_last_trades_by_instrument(
    instrument_name := 'BTC-PERPETUAL'
);

select *
from deribit.public_get_last_trades_by_instrument_and_time(
    instrument_name := 'BTC-PERPETUAL',
    start_timestamp := (extract(epoch from '2024-09-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-15'::timestamptz) * 1000)::bigint
);

-- TODO - find some data that gets returned
select *
from deribit.public_get_mark_price_history(
    instrument_name := 'BTC-25OCT24-60000-C',
    start_timestamp := (extract(epoch from '2024-09-10 00:00:00'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-10 12:00:00'::timestamptz) * 1000)::bigint
);

select *
from deribit.public_get_order_book(
    instrument_name := 'BTC-PERPETUAL',
    depth := '10'
);

select
    (deribit.unnest_2d_1d(asks))[1] as price,
    (deribit.unnest_2d_1d(asks))[2] as volume
from deribit.public_get_order_book(
    instrument_name := 'BTC-PERPETUAL',
    depth := '100'
);

select
    (deribit.unnest_2d_1d(asks))[1] as price,
    (deribit.unnest_2d_1d(asks))[2] as volume
from deribit.public_get_order_book_by_instrument_id(
    instrument_id := 296651,
    depth := '100'
);

select *
from deribit.public_get_supported_index_names(
    type := 'all'
);


select *
from deribit.public_get_trade_volumes(
    extended := true
);

select *
from deribit.public_get_tradingview_chart_data(
    instrument_name := 'BTC-PERPETUAL',
    start_timestamp := (extract(epoch from '2024-09-10 00:00:00'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-10 12:00:00'::timestamptz) * 1000)::bigint,
    resolution := '10'
);

-- todo - investigate this endpoint call for the continuation token
select *
from deribit.public_get_volatility_index_data(
    currency := 'BTC',
    start_timestamp := (extract(epoch from '2024-09-10 00:00:00'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-10 12:00:00'::timestamptz) * 1000)::bigint,
    resolution := '3600'
);

select *
from deribit.public_ticker(
    instrument_name := 'BTC-PERPETUAL'
);

select *
from deribit.public_ticker(
    instrument_name := 'BTC-25OCT24-60000-C'
);
