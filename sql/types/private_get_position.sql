drop type if exists deribit.private_get_position_response_result cascade;
create type deribit.private_get_position_response_result as (
	average_price double precision,
	average_price_usd double precision,
	delta double precision,
	direction text,
	estimated_liquidation_price double precision,
	floating_profit_loss double precision,
	floating_profit_loss_usd double precision,
	gamma double precision,
	index_price double precision,
	initial_margin double precision,
	instrument_name text,
	interest_value double precision,
	kind text,
	leverage bigint,
	maintenance_margin double precision,
	mark_price double precision,
	open_orders_margin double precision,
	realized_funding double precision,
	realized_profit_loss double precision,
	settlement_price double precision,
	size double precision,
	size_currency double precision,
	theta double precision,
	total_profit_loss double precision,
	vega double precision
);
comment on column deribit.private_get_position_response_result.average_price is 'Average price of trades that built this position';
comment on column deribit.private_get_position_response_result.average_price_usd is 'Only for options, average price in USD';
comment on column deribit.private_get_position_response_result.delta is 'Delta parameter';
comment on column deribit.private_get_position_response_result.direction is 'Direction: buy, sell or zero';
comment on column deribit.private_get_position_response_result.estimated_liquidation_price is 'Estimated liquidation price, added only for futures, for non portfolio margining users';
comment on column deribit.private_get_position_response_result.floating_profit_loss is 'Floating profit or loss';
comment on column deribit.private_get_position_response_result.floating_profit_loss_usd is 'Only for options, floating profit or loss in USD';
comment on column deribit.private_get_position_response_result.gamma is 'Only for options, Gamma parameter';
comment on column deribit.private_get_position_response_result.index_price is 'Current index price';
comment on column deribit.private_get_position_response_result.initial_margin is 'Initial margin';
comment on column deribit.private_get_position_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_position_response_result.interest_value is 'Value used to calculate realized_funding (perpetual only)';
comment on column deribit.private_get_position_response_result.kind is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.private_get_position_response_result.leverage is 'Current available leverage for future position';
comment on column deribit.private_get_position_response_result.maintenance_margin is 'Maintenance margin';
comment on column deribit.private_get_position_response_result.mark_price is 'Current mark price for position''s instrument';
comment on column deribit.private_get_position_response_result.open_orders_margin is 'Open orders margin';
comment on column deribit.private_get_position_response_result.realized_funding is 'Realized Funding in current session included in session realized profit or loss, only for positions of perpetual instruments';
comment on column deribit.private_get_position_response_result.realized_profit_loss is 'Realized profit or loss';
comment on column deribit.private_get_position_response_result.settlement_price is 'Optional (not added for spot). Last settlement price for position''s instrument 0 if instrument wasn''t settled yet';
comment on column deribit.private_get_position_response_result.size is 'Position size for futures size in quote currency (e.g. USD), for options size is in base currency (e.g. BTC)';
comment on column deribit.private_get_position_response_result.size_currency is 'Only for futures, position size in base currency';
comment on column deribit.private_get_position_response_result.theta is 'Only for options, Theta parameter';
comment on column deribit.private_get_position_response_result.total_profit_loss is 'Profit or loss from position';
comment on column deribit.private_get_position_response_result.vega is 'Only for options, Vega parameter';

drop type if exists deribit.private_get_position_response cascade;
create type deribit.private_get_position_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_position_response_result
);
comment on column deribit.private_get_position_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_position_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_get_position_request cascade;
create type deribit.private_get_position_request as (
	instrument_name text
);
comment on column deribit.private_get_position_request.instrument_name is '(Required) Instrument name';

