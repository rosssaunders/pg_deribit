create type deribit.public_get_last_trades_by_currency_and_time_response_trade as (
	amount float,
	block_trade_id text,
	block_trade_leg_count bigint,
	direction text,
	index_price float,
	instrument_name text,
	iv float,
	liquidation text,
	mark_price float,
	price float,
	tick_direction bigint,
	timestamp bigint,
	trade_id text,
	trade_seq bigint
);
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.amount is 'Trade amount. For perpetual and futures - in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.block_trade_id is 'Block trade id - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.block_trade_leg_count is 'Block trade leg count - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.direction is 'Direction: buy, or sell';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.index_price is 'Index Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.iv is 'Option implied volatility for the price (Option only)';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.liquidation is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.mark_price is 'Mark Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.price is 'Price in base currency';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.tick_direction is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.timestamp is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.trade_id is 'Unique (per currency) trade identifier';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade.trade_seq is 'The sequence number of the trade within instrument';

create type deribit.public_get_last_trades_by_currency_and_time_response_result as (
	has_more boolean,
	trades deribit.public_get_last_trades_by_currency_and_time_response_trade[]
);


create type deribit.public_get_last_trades_by_currency_and_time_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_last_trades_by_currency_and_time_response_result
);
comment on column deribit.public_get_last_trades_by_currency_and_time_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_last_trades_by_currency_and_time_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_last_trades_by_currency_and_time_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.public_get_last_trades_by_currency_and_time_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo', 'combo', 'any');

create type deribit.public_get_last_trades_by_currency_and_time_request_sorting as enum ('asc', 'desc', 'default');

create type deribit.public_get_last_trades_by_currency_and_time_request as (
	currency deribit.public_get_last_trades_by_currency_and_time_request_currency,
	kind deribit.public_get_last_trades_by_currency_and_time_request_kind,
	start_timestamp bigint,
	end_timestamp bigint,
	count bigint,
	sorting deribit.public_get_last_trades_by_currency_and_time_request_sorting
);
comment on column deribit.public_get_last_trades_by_currency_and_time_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_last_trades_by_currency_and_time_request.kind is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.public_get_last_trades_by_currency_and_time_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.public_get_last_trades_by_currency_and_time_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.public_get_last_trades_by_currency_and_time_request.count is 'Number of requested items, default - 10';
comment on column deribit.public_get_last_trades_by_currency_and_time_request.sorting is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create or replace function deribit.public_get_last_trades_by_currency_and_time(
	currency deribit.public_get_last_trades_by_currency_and_time_request_currency,
	kind deribit.public_get_last_trades_by_currency_and_time_request_kind default null,
	start_timestamp bigint,
	end_timestamp bigint,
	count bigint default null,
	sorting deribit.public_get_last_trades_by_currency_and_time_request_sorting default null
)
returns deribit.public_get_last_trades_by_currency_and_time_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_last_trades_by_currency_and_time_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		kind,
		start_timestamp,
		end_timestamp,
		count,
		sorting
    )::deribit.public_get_last_trades_by_currency_and_time_request;
    
    _http_response := (select deribit.jsonrpc_request('/public/get_last_trades_by_currency_and_time', _request));

    return (jsonb_populate_record(
        null::deribit.public_get_last_trades_by_currency_and_time_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_last_trades_by_currency_and_time is 'Retrieve the latest trades that have occurred for instruments in a specific currency symbol and within given time range.';

