drop type if exists deribit.public_ticker_response_stats cascade;
create type deribit.public_ticker_response_stats as (
	high float,
	low float,
	price_change float,
	volume float,
	volume_usd float,
	timestamp bigint,
	underlying_index float,
	underlying_price float
);
comment on column deribit.public_ticker_response_stats.high is 'Highest price during 24h';
comment on column deribit.public_ticker_response_stats.low is 'Lowest price during 24h';
comment on column deribit.public_ticker_response_stats.price_change is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_ticker_response_stats.volume is 'Volume during last 24h in base currency';
comment on column deribit.public_ticker_response_stats.volume_usd is 'Volume in usd (futures only)';
comment on column deribit.public_ticker_response_stats.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_ticker_response_stats.underlying_index is 'Name of the underlying future, or index_price (options only)';
comment on column deribit.public_ticker_response_stats.underlying_price is 'Underlying price for implied volatility calculations (options only)';

drop type if exists deribit.public_ticker_response_greeks cascade;
create type deribit.public_ticker_response_greeks as (
	delta float,
	gamma float,
	rho float,
	theta float,
	vega float,
	index_price float,
	instrument_name text,
	interest_rate float,
	interest_value float,
	last_price float,
	mark_iv float,
	mark_price float,
	max_price float,
	min_price float,
	open_interest float,
	settlement_price float,
	state text,
	stats deribit.public_ticker_response_stats
);
comment on column deribit.public_ticker_response_greeks.delta is '(Only for option) The delta value for the option';
comment on column deribit.public_ticker_response_greeks.gamma is '(Only for option) The gamma value for the option';
comment on column deribit.public_ticker_response_greeks.rho is '(Only for option) The rho value for the option';
comment on column deribit.public_ticker_response_greeks.theta is '(Only for option) The theta value for the option';
comment on column deribit.public_ticker_response_greeks.vega is '(Only for option) The vega value for the option';
comment on column deribit.public_ticker_response_greeks.index_price is 'Current index price';
comment on column deribit.public_ticker_response_greeks.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_ticker_response_greeks.interest_rate is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_ticker_response_greeks.interest_value is 'Value used to calculate realized_funding in positions (perpetual only)';
comment on column deribit.public_ticker_response_greeks.last_price is 'The price for the last trade';
comment on column deribit.public_ticker_response_greeks.mark_iv is '(Only for option) implied volatility for mark price';
comment on column deribit.public_ticker_response_greeks.mark_price is 'The mark price for the instrument';
comment on column deribit.public_ticker_response_greeks.max_price is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.public_ticker_response_greeks.min_price is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.public_ticker_response_greeks.open_interest is 'The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_ticker_response_greeks.settlement_price is 'Optional (not added for spot). The settlement price for the instrument. Only when state = open';
comment on column deribit.public_ticker_response_greeks.state is 'The state of the order book. Possible values are open and closed.';

drop type if exists deribit.public_ticker_response_result cascade;
create type deribit.public_ticker_response_result as (
	ask_iv float,
	best_ask_amount float,
	best_ask_price float,
	best_bid_amount float,
	best_bid_price float,
	bid_iv float,
	current_funding float,
	delivery_price float,
	estimated_delivery_price float,
	funding_8h float,
	greeks deribit.public_ticker_response_greeks
);
comment on column deribit.public_ticker_response_result.ask_iv is '(Only for option) implied volatility for best ask';
comment on column deribit.public_ticker_response_result.best_ask_amount is 'It represents the requested order size of all best asks';
comment on column deribit.public_ticker_response_result.best_ask_price is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_ticker_response_result.best_bid_amount is 'It represents the requested order size of all best bids';
comment on column deribit.public_ticker_response_result.best_bid_price is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_ticker_response_result.bid_iv is '(Only for option) implied volatility for best bid';
comment on column deribit.public_ticker_response_result.current_funding is 'Current funding (perpetual only)';
comment on column deribit.public_ticker_response_result.delivery_price is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_ticker_response_result.estimated_delivery_price is 'Estimated delivery price for the market. For more details, see Contract Specification > General Documentation > Expiration Price';
comment on column deribit.public_ticker_response_result.funding_8h is 'Funding 8h (perpetual only)';
comment on column deribit.public_ticker_response_result.greeks is 'Only for options';

drop type if exists deribit.public_ticker_response cascade;
create type deribit.public_ticker_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_ticker_response_result
);
comment on column deribit.public_ticker_response.id is 'The id that was sent in the request';
comment on column deribit.public_ticker_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_ticker_request cascade;
create type deribit.public_ticker_request as (
	instrument_name text
);
comment on column deribit.public_ticker_request.instrument_name is '(Required) Instrument name';

