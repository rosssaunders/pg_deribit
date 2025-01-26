-----------------------------------------------------------------------
-- Examples of how to call to get instrument static and live pricing
-----------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

-- Returns the instrument details for ETH-PERPETUAL
select *
from deribit.public_get_instrument(instrument_name := 'ETH-PERPETUAL');

-- Returns the index price names
select *
from deribit.public_get_index_price_names();

-- Returns the book summary for BTC
select *
from deribit.public_get_book_summary_by_currency(
    'BTC'::deribit.public_get_book_summary_by_currency_request_currency
);

-- Returns the book summary for ETH-PERPETUAL instrument
select *
from deribit.public_get_book_summary_by_instrument(
    'ETH-PERPETUAL'
);

-- Returns the Contract Size for BTC-PERPETUAL
select *
from deribit.public_get_contract_size('BTC-PERPETUAL');

-- Returns the currencies supported by Deribit
select *
from deribit.public_get_currencies();
