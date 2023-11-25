drop type if exists deribit.private_edit_response_leg cascade;
create type deribit.private_edit_response_leg as (
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
comment on column deribit.private_edit_response_leg.liquidation is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_edit_response_leg.liquidity is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_edit_response_leg.mark_price is 'Mark Price at the moment of trade';
comment on column deribit.private_edit_response_leg.matching_id is 'Always null';
comment on column deribit.private_edit_response_leg.mmp is 'true if user order is MMP';
comment on column deribit.private_edit_response_leg.order_id is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_edit_response_leg.order_type is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_edit_response_leg.post_only is 'true if user order is post-only';
comment on column deribit.private_edit_response_leg.price is 'Price in base currency';
comment on column deribit.private_edit_response_leg.profit_loss is 'Profit and loss in base currency.';
comment on column deribit.private_edit_response_leg.reduce_only is 'true if user order is reduce-only';
comment on column deribit.private_edit_response_leg.risk_reducing is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_edit_response_leg.state is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_edit_response_leg.tick_direction is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_edit_response_leg.timestamp is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_edit_response_leg.trade_id is 'Unique (per currency) trade identifier';
comment on column deribit.private_edit_response_leg.trade_seq is 'The sequence number of the trade within instrument';
comment on column deribit.private_edit_response_leg.underlying_price is 'Underlying price for implied volatility calculations (Options only)';

drop type if exists deribit.private_edit_response_trade cascade;
create type deribit.private_edit_response_trade as (
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
	legs deribit.private_edit_response_leg[]
);
comment on column deribit.private_edit_response_trade.advanced is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';
comment on column deribit.private_edit_response_trade.amount is 'Trade amount. For perpetual and futures - in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_response_trade.api is 'true if user order was created with API';
comment on column deribit.private_edit_response_trade.block_trade_id is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_edit_response_trade.combo_id is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_edit_response_trade.combo_trade_id is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_edit_response_trade.direction is 'Direction: buy, or sell';
comment on column deribit.private_edit_response_trade.fee is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_edit_response_trade.fee_currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_edit_response_trade.index_price is 'Index Price at the moment of trade';
comment on column deribit.private_edit_response_trade.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_edit_response_trade.iv is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_edit_response_trade.label is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_edit_response_trade.legs is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';

drop type if exists deribit.private_edit_response_order cascade;
create type deribit.private_edit_response_order as (
	reject_post_only boolean,
	label text,
	order_state text,
	usd double precision,
	implv double precision,
	trigger_reference_price double precision,
	original_order_type text,
	block_trade boolean,
	trigger_price double precision,
	api boolean,
	mmp boolean,
	trigger_order_id text,
	cancel_reason text,
	risk_reducing boolean,
	filled_amount double precision,
	instrument_name text,
	max_show double precision,
	app_name text,
	mmp_cancelled boolean,
	direction text,
	last_update_timestamp bigint,
	trigger_offset double precision,
	price text,
	is_liquidation boolean,
	reduce_only boolean,
	amount double precision,
	post_only boolean,
	mobile boolean,
	triggered boolean,
	order_id text,
	replaced boolean,
	order_type text,
	time_in_force text,
	auto_replaced boolean,
	trigger text,
	web boolean,
	creation_timestamp bigint,
	average_price double precision,
	advanced text,
	trades deribit.private_edit_response_trade[]
);
comment on column deribit.private_edit_response_order.reject_post_only is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_edit_response_order.label is 'User defined label (up to 64 characters)';
comment on column deribit.private_edit_response_order.order_state is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_edit_response_order.usd is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_edit_response_order.implv is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_edit_response_order.trigger_reference_price is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_edit_response_order.original_order_type is 'Original order type. Optional field';
comment on column deribit.private_edit_response_order.block_trade is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_edit_response_order.trigger_price is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_edit_response_order.api is 'true if created with API';
comment on column deribit.private_edit_response_order.mmp is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_edit_response_order.trigger_order_id is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_edit_response_order.cancel_reason is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting)';
comment on column deribit.private_edit_response_order.risk_reducing is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_edit_response_order.filled_amount is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_response_order.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_edit_response_order.max_show is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_edit_response_order.app_name is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_edit_response_order.mmp_cancelled is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_edit_response_order.direction is 'Direction: buy, or sell';
comment on column deribit.private_edit_response_order.last_update_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_edit_response_order.trigger_offset is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_edit_response_order.price is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_edit_response_order.is_liquidation is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_edit_response_order.reduce_only is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_edit_response_order.amount is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_response_order.post_only is 'true for post-only orders only';
comment on column deribit.private_edit_response_order.mobile is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_edit_response_order.triggered is 'Whether the trigger order has been triggered';
comment on column deribit.private_edit_response_order.order_id is 'Unique order identifier';
comment on column deribit.private_edit_response_order.replaced is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_edit_response_order.order_type is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_edit_response_order.time_in_force is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_edit_response_order.auto_replaced is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_edit_response_order.trigger is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_edit_response_order.web is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_edit_response_order.creation_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_edit_response_order.average_price is 'Average fill price of the order';
comment on column deribit.private_edit_response_order.advanced is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

drop type if exists deribit.private_edit_response_result cascade;
create type deribit.private_edit_response_result as (
	"order" deribit.private_edit_response_order
);


drop type if exists deribit.private_edit_response cascade;
create type deribit.private_edit_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_edit_response_result
);
comment on column deribit.private_edit_response.id is 'The id that was sent in the request';
comment on column deribit.private_edit_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_edit_request_advanced cascade;
create type deribit.private_edit_request_advanced as enum ('usd', 'implv');

drop type if exists deribit.private_edit_request cascade;
create type deribit.private_edit_request as (
	order_id text,
	amount double precision,
	price double precision,
	post_only boolean,
	reduce_only boolean,
	reject_post_only boolean,
	advanced deribit.private_edit_request_advanced,
	trigger_price double precision,
	trigger_offset double precision,
	mmp boolean,
	valid_until bigint
);
comment on column deribit.private_edit_request.order_id is '(Required) The order id';
comment on column deribit.private_edit_request.amount is '(Required) It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is underlying base currency coin. For options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_edit_request.price is 'The order price in base currency. When editing an option order with advanced=usd, the field price should be the option price value in USD. When editing an option order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_edit_request.post_only is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just below or above the spread (accordingly to the original order type). Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_edit_request.reduce_only is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_edit_request.reject_post_only is 'If an order is considered post-only and this field is set to true then the order is put to order book unmodified or request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_edit_request.advanced is 'Advanced option order type. If you have posted an advanced option order, it is necessary to re-supply this parameter when editing it (Only for options)';
comment on column deribit.private_edit_request.trigger_price is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_edit_request.trigger_offset is 'The maximum deviation from the price peak beyond which the order will be triggered';
comment on column deribit.private_edit_request.mmp is 'Order MMP flag, only for order_type ''limit''';
comment on column deribit.private_edit_request.valid_until is 'Timestamp, when provided server will start processing request in Matching Engine only before given timestamp, in other cases timed_out error will be responded. Remember that the given timestamp should be consistent with the server''s time, use /public/time method to obtain current server time.';

