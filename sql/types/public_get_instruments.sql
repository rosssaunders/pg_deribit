drop type if exists deribit.public_get_instruments_response_tick_size_step cascade;
create type deribit.public_get_instruments_response_tick_size_step as (
	above_price double precision,
	tick_size double precision
);
comment on column deribit.public_get_instruments_response_tick_size_step.above_price is 'The price from which the increased tick size applies';
comment on column deribit.public_get_instruments_response_tick_size_step.tick_size is 'Tick size to be used above the price. It must be multiple of the minimum tick size.';

drop type if exists deribit.public_get_instruments_response_result cascade;
create type deribit.public_get_instruments_response_result as (
	base_currency text,
	block_trade_commission double precision,
	block_trade_min_trade_amount double precision,
	block_trade_tick_size double precision,
	contract_size double precision,
	counter_currency text,
	creation_timestamp bigint,
	expiration_timestamp bigint,
	future_type text,
	instrument_id bigint,
	instrument_name text,
	is_active boolean,
	kind text,
	maker_commission double precision,
	max_leverage bigint,
	max_liquidation_commission double precision,
	min_trade_amount double precision,
	option_type text,
	price_index text,
	quote_currency text,
	rfq boolean,
	settlement_currency text,
	settlement_period text,
	strike double precision,
	taker_commission double precision,
	tick_size double precision,
	tick_size_steps deribit.public_get_instruments_response_tick_size_step[]
);
comment on column deribit.public_get_instruments_response_result.base_currency is 'The underlying currency being traded.';
comment on column deribit.public_get_instruments_response_result.block_trade_commission is 'Block Trade commission for instrument.';
comment on column deribit.public_get_instruments_response_result.block_trade_min_trade_amount is 'Minimum amount for block trading.';
comment on column deribit.public_get_instruments_response_result.block_trade_tick_size is 'Specifies minimal price change for block trading.';
comment on column deribit.public_get_instruments_response_result.contract_size is 'Contract size for instrument.';
comment on column deribit.public_get_instruments_response_result.counter_currency is 'Counter currency for the instrument.';
comment on column deribit.public_get_instruments_response_result.creation_timestamp is 'The time when the instrument was first created (milliseconds since the UNIX epoch).';
comment on column deribit.public_get_instruments_response_result.expiration_timestamp is 'The time when the instrument will expire (milliseconds since the UNIX epoch).';
comment on column deribit.public_get_instruments_response_result.future_type is 'Future type (only for futures).';
comment on column deribit.public_get_instruments_response_result.instrument_id is 'Instrument ID';
comment on column deribit.public_get_instruments_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_get_instruments_response_result.is_active is 'Indicates if the instrument can currently be traded.';
comment on column deribit.public_get_instruments_response_result.kind is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.public_get_instruments_response_result.maker_commission is 'Maker commission for instrument.';
comment on column deribit.public_get_instruments_response_result.max_leverage is 'Maximal leverage for instrument (only for futures).';
comment on column deribit.public_get_instruments_response_result.max_liquidation_commission is 'Maximal liquidation trade commission for instrument (only for futures).';
comment on column deribit.public_get_instruments_response_result.min_trade_amount is 'Minimum amount for trading. For perpetual and futures - in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_instruments_response_result.option_type is 'The option type (only for options).';
comment on column deribit.public_get_instruments_response_result.price_index is 'Name of price index that is used for this instrument';
comment on column deribit.public_get_instruments_response_result.quote_currency is 'The currency in which the instrument prices are quoted.';
comment on column deribit.public_get_instruments_response_result.rfq is 'Whether or not RFQ is active on the instrument.';
comment on column deribit.public_get_instruments_response_result.settlement_currency is 'Optional (not added for spot). Settlement currency for the instrument.';
comment on column deribit.public_get_instruments_response_result.settlement_period is 'Optional (not added for spot). The settlement period.';
comment on column deribit.public_get_instruments_response_result.strike is 'The strike value (only for options).';
comment on column deribit.public_get_instruments_response_result.taker_commission is 'Taker commission for instrument.';
comment on column deribit.public_get_instruments_response_result.tick_size is 'Specifies minimal price change and, as follows, the number of decimal places for instrument prices.';

drop type if exists deribit.public_get_instruments_response cascade;
create type deribit.public_get_instruments_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_instruments_response_result[]
);
comment on column deribit.public_get_instruments_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_instruments_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_instruments_request_currency cascade;
create type deribit.public_get_instruments_request_currency as enum ('BTC', 'USDC', 'ETH');

drop type if exists deribit.public_get_instruments_request_kind cascade;
create type deribit.public_get_instruments_request_kind as enum ('option', 'future', 'option_combo', 'spot', 'future_combo');

drop type if exists deribit.public_get_instruments_request cascade;
create type deribit.public_get_instruments_request as (
	currency deribit.public_get_instruments_request_currency,
	kind deribit.public_get_instruments_request_kind,
	expired boolean
);
comment on column deribit.public_get_instruments_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_instruments_request.kind is 'Instrument kind, if not provided instruments of all kinds are considered';
comment on column deribit.public_get_instruments_request.expired is 'Set to true to show recently expired instruments instead of active ones.';

