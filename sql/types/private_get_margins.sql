create type deribit.private_get_margins_response_result as (
	buy float,
	max_price float,
	min_price float,
	sell float
);
comment on column deribit.private_get_margins_response_result.buy is 'Margin when buying';
comment on column deribit.private_get_margins_response_result.max_price is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.private_get_margins_response_result.min_price is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.private_get_margins_response_result.sell is 'Margin when selling';

create type deribit.private_get_margins_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_margins_response_result
);
comment on column deribit.private_get_margins_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_margins_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_margins_request as (
	instrument_name text,
	amount float,
	price float
);
comment on column deribit.private_get_margins_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_get_margins_request.amount is '(Required) Amount, integer for future, float for option. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_margins_request.price is '(Required) Price';

