drop type if exists deribit.public_get_book_summary_by_currency_response_result cascade;
create type deribit.public_get_book_summary_by_currency_response_result as (
	ask_price double precision,
	base_currency text,
	bid_price double precision,
	creation_timestamp bigint,
	current_funding double precision,
	estimated_delivery_price double precision,
	funding_8h double precision,
	high double precision,
	instrument_name text,
	interest_rate double precision,
	last double precision,
	low double precision,
	mark_price double precision,
	mid_price double precision,
	open_interest double precision,
	price_change double precision,
	quote_currency text,
	underlying_index text,
	underlying_price double precision,
	volume double precision,
	volume_notional double precision,
	volume_usd double precision
);
comment on column deribit.public_get_book_summary_by_currency_response_result.ask_price is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_book_summary_by_currency_response_result.base_currency is 'Base currency';
comment on column deribit.public_get_book_summary_by_currency_response_result.bid_price is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_book_summary_by_currency_response_result.creation_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_book_summary_by_currency_response_result.current_funding is 'Current funding (perpetual only)';
comment on column deribit.public_get_book_summary_by_currency_response_result.estimated_delivery_price is 'Optional (only for derivatives). Estimated delivery price for the market. For more details, see Contract Specification > General Documentation > Expiration Price.';
comment on column deribit.public_get_book_summary_by_currency_response_result.funding_8h is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_book_summary_by_currency_response_result.high is 'Price of the 24h highest trade';
comment on column deribit.public_get_book_summary_by_currency_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_get_book_summary_by_currency_response_result.interest_rate is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_currency_response_result.last is 'The price of the latest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_currency_response_result.low is 'Price of the 24h lowest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_currency_response_result.mark_price is 'The current instrument market price';
comment on column deribit.public_get_book_summary_by_currency_response_result.mid_price is 'The average of the best bid and ask, null if there aren''t any asks or bids';
comment on column deribit.public_get_book_summary_by_currency_response_result.open_interest is 'Optional (only for derivatives). The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_book_summary_by_currency_response_result.price_change is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_currency_response_result.quote_currency is 'Quote currency';
comment on column deribit.public_get_book_summary_by_currency_response_result.underlying_index is 'Name of the underlying future, or ''index_price'' (options only)';
comment on column deribit.public_get_book_summary_by_currency_response_result.underlying_price is 'underlying price for implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_currency_response_result.volume is 'The total 24h traded volume (in base currency)';
comment on column deribit.public_get_book_summary_by_currency_response_result.volume_notional is 'Volume in quote currency (futures and spots only)';
comment on column deribit.public_get_book_summary_by_currency_response_result.volume_usd is 'Volume in USD';

drop type if exists deribit.public_get_book_summary_by_currency_response cascade;
create type deribit.public_get_book_summary_by_currency_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_book_summary_by_currency_response_result[]
);
comment on column deribit.public_get_book_summary_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_book_summary_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_book_summary_by_currency_request_currency cascade;
create type deribit.public_get_book_summary_by_currency_request_currency as enum ('ETH', 'BTC', 'USDC');

drop type if exists deribit.public_get_book_summary_by_currency_request_kind cascade;
create type deribit.public_get_book_summary_by_currency_request_kind as enum ('future', 'option_combo', 'future_combo', 'spot', 'option');

drop type if exists deribit.public_get_book_summary_by_currency_request cascade;
create type deribit.public_get_book_summary_by_currency_request as (
	currency deribit.public_get_book_summary_by_currency_request_currency,
	kind deribit.public_get_book_summary_by_currency_request_kind
);
comment on column deribit.public_get_book_summary_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_book_summary_by_currency_request.kind is 'Instrument kind, if not provided instruments of all kinds are considered';

