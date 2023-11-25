drop type if exists deribit.private_get_user_trades_by_instrument_response_leg cascade;
create type deribit.private_get_user_trades_by_instrument_response_leg as (
	liquidation text,
	liquidity text,
	mark_price double precision,
	matching_id text,
	mmp boolean,
	order_id text,
	order_type text,
	post_only text,
	price double precision,
	profit_loss double precision,
	reduce_only text,
	risk_reducing boolean,
	state text,
	tick_direction bigint,
	timestamp bigint,
	trade_id text,
	trade_seq bigint,
	underlying_price double precision
);
comment on column deribit.private_get_user_trades_by_instrument_response_leg.liquidation is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.liquidity is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.mark_price is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.matching_id is 'Always null';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.mmp is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.order_id is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.order_type is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.post_only is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.price is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.profit_loss is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.reduce_only is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.risk_reducing is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.state is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.tick_direction is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.timestamp is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.trade_id is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.trade_seq is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_instrument_response_leg.underlying_price is 'Underlying price for implied volatility calculations (Options only)';

drop type if exists deribit.private_get_user_trades_by_instrument_response_trade cascade;
create type deribit.private_get_user_trades_by_instrument_response_trade as (
	advanced text,
	amount double precision,
	api boolean,
	block_trade_id text,
	combo_id text,
	combo_trade_id double precision,
	direction text,
	fee double precision,
	fee_currency text,
	index_price double precision,
	instrument_name text,
	iv double precision,
	label text,
	legs deribit.private_get_user_trades_by_instrument_response_leg[]
);
comment on column deribit.private_get_user_trades_by_instrument_response_trade.advanced is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.amount is 'Trade amount. For perpetual and futures - in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.api is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.block_trade_id is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.combo_id is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.combo_trade_id is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.direction is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.fee is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.fee_currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.index_price is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.iv is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.label is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade.legs is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';

drop type if exists deribit.private_get_user_trades_by_instrument_response_result cascade;
create type deribit.private_get_user_trades_by_instrument_response_result as (
	has_more boolean,
	trades deribit.private_get_user_trades_by_instrument_response_trade[]
);


drop type if exists deribit.private_get_user_trades_by_instrument_response cascade;
create type deribit.private_get_user_trades_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_user_trades_by_instrument_response_result
);
comment on column deribit.private_get_user_trades_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_get_user_trades_by_instrument_request_sorting cascade;
create type deribit.private_get_user_trades_by_instrument_request_sorting as enum ('default', 'desc', 'asc');

drop type if exists deribit.private_get_user_trades_by_instrument_request cascade;
create type deribit.private_get_user_trades_by_instrument_request as (
	instrument_name text,
	start_seq bigint,
	end_seq bigint,
	count bigint,
	start_timestamp bigint,
	end_timestamp bigint,
	sorting deribit.private_get_user_trades_by_instrument_request_sorting
);
comment on column deribit.private_get_user_trades_by_instrument_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_get_user_trades_by_instrument_request.start_seq is 'The sequence number of the first trade to be returned';
comment on column deribit.private_get_user_trades_by_instrument_request.end_seq is 'The sequence number of the last trade to be returned';
comment on column deribit.private_get_user_trades_by_instrument_request.count is 'Number of requested items, default - 10';
comment on column deribit.private_get_user_trades_by_instrument_request.start_timestamp is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.private_get_user_trades_by_instrument_request.end_timestamp is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.private_get_user_trades_by_instrument_request.sorting is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

