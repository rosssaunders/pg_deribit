create extension if not exists omni_httpc;

drop type if exists deribit_future;
create type deribit_future AS (
    rfq text,
    kind text,
    is_active text,
    tick_size text,
    future_type text,
    price_index text,
    max_leverage text,
    base_currency text,
    contract_size text,
    instrument_id text,
    quote_currency text,
    instrument_name text,
    instrument_type text,
    tick_size_steps text,
    counter_currency text,
    maker_commission text,
    min_trade_amount text,
    taker_commission text,
    settlement_period text,
    creation_timestamp text,
    settlement_currency text,
    expiration_timestamp text,
    block_trade_tick_size text,
    block_trade_commission text,
    max_liquidation_commission text,
    block_trade_min_trade_amount text
);

select i.*
from
    omni_httpc.http_execute(
        omni_httpc.http_request('https://test.deribit.com/api/v2/public/get_instruments?currency=BTC&kind=future')
    ) h
cross join lateral jsonb_populate_recordset(null::deribit_future, convert_from(body, 'utf-8')::jsonb -> 'result') i;
