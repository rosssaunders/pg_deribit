drop type if exists deribit.public_get_book_summary_by_instrument_response_result cascade;
create type deribit.public_get_book_summary_by_instrument_response_result as (
	ask_price float,
	base_currency text,
	bid_price float,
	creation_timestamp bigint,
	current_funding float,
	estimated_delivery_price float,
	funding_8h float,
	high float,
	instrument_name text,
	interest_rate float,
	last float,
	low float,
	mark_price float,
	mid_price float,
	open_interest float,
	price_change float,
	quote_currency text,
	underlying_index text,
	underlying_price float,
	volume float,
	volume_notional float,
	volume_usd float
);
comment on column deribit.public_get_book_summary_by_instrument_response_result.ask_price is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_book_summary_by_instrument_response_result.base_currency is 'Base currency';
comment on column deribit.public_get_book_summary_by_instrument_response_result.bid_price is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_book_summary_by_instrument_response_result.creation_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.current_funding is 'Current funding (perpetual only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.estimated_delivery_price is 'Optional (only for derivatives). Estimated delivery price for the market. For more details, see Contract Specification > General Documentation > Expiration Price.';
comment on column deribit.public_get_book_summary_by_instrument_response_result.funding_8h is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.high is 'Price of the 24h highest trade';
comment on column deribit.public_get_book_summary_by_instrument_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_get_book_summary_by_instrument_response_result.interest_rate is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.last is 'The price of the latest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_instrument_response_result.low is 'Price of the 24h lowest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_instrument_response_result.mark_price is 'The current instrument market price';
comment on column deribit.public_get_book_summary_by_instrument_response_result.mid_price is 'The average of the best bid and ask, null if there aren''t any asks or bids';
comment on column deribit.public_get_book_summary_by_instrument_response_result.open_interest is 'Optional (only for derivatives). The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_book_summary_by_instrument_response_result.price_change is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_instrument_response_result.quote_currency is 'Quote currency';
comment on column deribit.public_get_book_summary_by_instrument_response_result.underlying_index is 'Name of the underlying future, or ''index_price'' (options only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.underlying_price is 'underlying price for implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.volume is 'The total 24h traded volume (in base currency)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.volume_notional is 'Volume in quote currency (futures and spots only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result.volume_usd is 'Volume in USD';

drop type if exists deribit.public_get_book_summary_by_instrument_response cascade;
create type deribit.public_get_book_summary_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_book_summary_by_instrument_response_result[]
);
comment on column deribit.public_get_book_summary_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_book_summary_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_book_summary_by_instrument_request cascade;
create type deribit.public_get_book_summary_by_instrument_request as (
	instrument_name text
);
comment on column deribit.public_get_book_summary_by_instrument_request.instrument_name is '(Required) Instrument name';

