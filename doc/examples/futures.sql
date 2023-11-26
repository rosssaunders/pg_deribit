do $$
declare
    password text = 'my_super_secret_password';
begin
    perform deribit.decrypt_and_store_in_session(password);
end
$$;

select *
from deribit.public_get_instrument(instrument_name := 'ETH-PERPETUAL');

select *
from deribit.public_get_index_price_names();

-- all public in order

select *
from deribit.public_get_announcements(1, 100);

select *
from deribit.public_get_book_summary_by_currency(
    'BTC'::deribit.public_get_book_summary_by_currency_request_currency);

select *
from deribit.public_get_book_summary_by_instrument(
    'ETH-PERPETUAL');

select *
from deribit.public_get_contract_size('BTC-PERPETUAL');

select *
from deribit.public_get_currencies();

select *
from deribit.public_get_funding_rate_history(
'ETH-PERPETUAL',
extract(epoch from '2022-10-01'::timestamptz)::bigint,
extract(epoch from '2023-11-01'::timestamptz)::bigint
);
