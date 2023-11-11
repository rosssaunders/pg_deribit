create type deribit.private_get_user_trades_by_order_response as (
	id bigint,
	jsonrpc text,
	array of UNKNOWN - advanced,
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
comment on column deribit.private_get_user_trades_by_order_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_order_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_user_trades_by_order_response.array of is 'string';
comment on column deribit.private_get_user_trades_by_order_response.amount is 'Trade amount. For perpetual and futures - in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_order_response.api is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_order_response.block_trade_id is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_order_response.combo_id is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_order_response.combo_trade_id is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_order_response.direction is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_order_response.fee is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_order_response.fee_currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_order_response.index_price is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_order_response.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_order_response.iv is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_order_response.label is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_order_response.legs is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_order_response.liquidation is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_order_response.liquidity is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_order_response.mark_price is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_order_response.matching_id is 'Always null';
comment on column deribit.private_get_user_trades_by_order_response.mmp is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_order_response.order_id is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_order_response.order_type is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_order_response.post_only is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_order_response.price is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_order_response.profit_loss is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_order_response.reduce_only is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_order_response.risk_reducing is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_order_response.state is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_order_response.tick_direction is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_order_response.timestamp is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_order_response.trade_id is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_order_response.trade_seq is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_order_response.underlying_price is 'Underlying price for implied volatility calculations (Options only)';

create type deribit.private_get_user_trades_by_order_request_sorting as enum ('asc', 'desc', 'default');

create type deribit.private_get_user_trades_by_order_request as (
	order_id text,
	sorting deribit.private_get_user_trades_by_order_request_sorting
);
comment on column deribit.private_get_user_trades_by_order_request.order_id is '(Required) The order id';
comment on column deribit.private_get_user_trades_by_order_request.sorting is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create or replace function deribit.private_get_user_trades_by_order(
	order_id text,
	sorting deribit.private_get_user_trades_by_order_request_sorting default null
)
returns deribit.private_get_user_trades_by_order_response
language plpgsql
as $$
declare
	_request deribit.private_get_user_trades_by_order_request;
	_response deribit.private_get_user_trades_by_order_response;
begin
	_request := row(
		order_id,
		sorting
	)::deribit.private_get_user_trades_by_order_request;

	with request as (
		select json_build_object(
			'method', '/private/get_user_trades_by_order',
			'params', jsonb_strip_nulls(to_jsonb(_request)),
			'jsonrpc', '2.0',
			'id', 3
		) as request
	),
	auth as (
		select
			'Authorization' as key,
			'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value
	),
	url as (
		select format('%s%s', base_url, end_point) as url
		from
		(
			select
				'https://test.deribit.com/api/v2' as base_url,
				'/private/get_user_trades_by_order' as end_point
		) as a
	),
	exec as (
		select
			version,
			status,
			headers,
			body,
			error
		from request
		cross join auth
		cross join url
		cross join omni_httpc.http_execute(
			omni_httpc.http_request(
				method := 'POST',
				url := url.url,
				body := request.request::text::bytea,
				headers := array[row (auth.key, auth.value)::omni_http.http_header])
		) as response
	)
	select
		i.id,
		i.jsonrpc,
		i.result
	into
		_response
	from exec
	cross join lateral jsonb_populate_record(null::deribit.private_get_user_trades_by_order_response, convert_from(body, 'utf-8')::jsonb) i;

	return _response;
end;
$$;
comment on function deribit.private_get_user_trades_by_order is 'Retrieve the list of user trades that was created for given order';

