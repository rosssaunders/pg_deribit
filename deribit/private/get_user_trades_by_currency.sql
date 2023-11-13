insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_user_trades_by_currency', now(), 0, '0 secs'::interval);

create type deribit.private_get_user_trades_by_currency_response_trade as (
	advanced text,
	amount float,
	api boolean,
	block_trade_id text,
	combo_id text,
	combo_trade_id float,
	direction text,
	fee float,
	fee_currency text,
	index_price float,
	instrument_name text,
	iv float,
	label text,
	legs text[],
	liquidation text,
	liquidity text,
	mark_price float,
	matching_id text,
	mmp boolean,
	order_id text,
	order_type text,
	post_only text,
	price float,
	profit_loss float,
	reduce_only text,
	risk_reducing boolean,
	state text,
	tick_direction bigint,
	timestamp bigint,
	trade_id text,
	trade_seq bigint,
	underlying_price float
);
comment on column deribit.private_get_user_trades_by_currency_response_trade.advanced is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.amount is 'Trade amount. For perpetual and futures - in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_currency_response_trade.api is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_currency_response_trade.block_trade_id is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade.combo_id is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade.combo_trade_id is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade.direction is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_currency_response_trade.fee is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_currency_response_trade.fee_currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_currency_response_trade.index_price is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_currency_response_trade.iv is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.label is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.legs is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.liquidation is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_currency_response_trade.liquidity is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_currency_response_trade.mark_price is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade.matching_id is 'Always null';
comment on column deribit.private_get_user_trades_by_currency_response_trade.mmp is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_currency_response_trade.order_id is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade.order_type is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_currency_response_trade.post_only is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_currency_response_trade.price is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_currency_response_trade.profit_loss is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_currency_response_trade.reduce_only is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_currency_response_trade.risk_reducing is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.state is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.tick_direction is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_currency_response_trade.timestamp is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_currency_response_trade.trade_id is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_currency_response_trade.trade_seq is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_currency_response_trade.underlying_price is 'Underlying price for implied volatility calculations (Options only)';

create type deribit.private_get_user_trades_by_currency_response_result as (
	has_more boolean,
	trades deribit.private_get_user_trades_by_currency_response_trade[]
);


create type deribit.private_get_user_trades_by_currency_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_user_trades_by_currency_response_result
);
comment on column deribit.private_get_user_trades_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_user_trades_by_currency_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_user_trades_by_currency_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo', 'combo', 'any');

create type deribit.private_get_user_trades_by_currency_request_sorting as enum ('asc', 'desc', 'default');

create type deribit.private_get_user_trades_by_currency_request as (
	currency deribit.private_get_user_trades_by_currency_request_currency,
	kind deribit.private_get_user_trades_by_currency_request_kind,
	start_id text,
	end_id text,
	count bigint,
	start_timestamp bigint,
	end_timestamp bigint,
	sorting deribit.private_get_user_trades_by_currency_request_sorting,
	subaccount_id bigint
);
comment on column deribit.private_get_user_trades_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_user_trades_by_currency_request.kind is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_get_user_trades_by_currency_request.start_id is 'The ID of the first trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.private_get_user_trades_by_currency_request.end_id is 'The ID of the last trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.private_get_user_trades_by_currency_request.count is 'Number of requested items, default - 10';
comment on column deribit.private_get_user_trades_by_currency_request.start_timestamp is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.private_get_user_trades_by_currency_request.end_timestamp is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.private_get_user_trades_by_currency_request.sorting is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';
comment on column deribit.private_get_user_trades_by_currency_request.subaccount_id is 'The user id for the subaccount';

create or replace function deribit.private_get_user_trades_by_currency(
	currency deribit.private_get_user_trades_by_currency_request_currency,
	kind deribit.private_get_user_trades_by_currency_request_kind default null,
	start_id text default null,
	end_id text default null,
	count bigint default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	sorting deribit.private_get_user_trades_by_currency_request_sorting default null,
	subaccount_id bigint default null
)
returns deribit.private_get_user_trades_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_user_trades_by_currency_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		kind,
		start_id,
		end_id,
		count,
		start_timestamp,
		end_timestamp,
		sorting,
		subaccount_id
    )::deribit.private_get_user_trades_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_user_trades_by_currency', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_user_trades_by_currency is 'Retrieve the latest user trades that have occurred for instruments in a specific currency symbol. To read subaccount trades, use subaccount_id parameter.';

