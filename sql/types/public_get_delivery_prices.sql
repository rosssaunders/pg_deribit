drop type if exists deribit.public_get_delivery_prices_response_datum cascade;
create type deribit.public_get_delivery_prices_response_datum as (
	date text,
	delivery_price float,
	records_total float
);
comment on column deribit.public_get_delivery_prices_response_datum.date is 'The event date with year, month and day';
comment on column deribit.public_get_delivery_prices_response_datum.delivery_price is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_get_delivery_prices_response_datum.records_total is 'Available delivery prices';

drop type if exists deribit.public_get_delivery_prices_response_result cascade;
create type deribit.public_get_delivery_prices_response_result as (
	data deribit.public_get_delivery_prices_response_datum[]
);


drop type if exists deribit.public_get_delivery_prices_response cascade;
create type deribit.public_get_delivery_prices_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_delivery_prices_response_result
);
comment on column deribit.public_get_delivery_prices_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_delivery_prices_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_delivery_prices_request_index_name cascade;
create type deribit.public_get_delivery_prices_request_index_name as enum ('near_usd', 'algo_usd', 'btcdvol_usdc', 'dot_usdc', 'avax_usdc', 'usdc_usd', 'sol_usdc', 'algo_usdc', 'matic_usd', 'xrp_usd', 'ltc_usdc', 'matic_usdc', 'doge_usdc', 'ada_usdc', 'link_usdc', 'avax_usd', 'ltc_usd', 'bch_usdc', 'near_usdc', 'trx_usdc', 'ada_usd', 'doge_usd', 'shib_usd', 'link_usd', 'btc_usdc', 'shib_usdc', 'uni_usdc', 'dot_usd', 'btc_usd', 'bch_usd', 'sol_usd', 'trx_usd', 'eth_usdc', 'eth_usd', 'xrp_usdc', 'uni_usd', 'ethdvol_usdc');

drop type if exists deribit.public_get_delivery_prices_request cascade;
create type deribit.public_get_delivery_prices_request as (
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint,
	count bigint
);
comment on column deribit.public_get_delivery_prices_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.public_get_delivery_prices_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.public_get_delivery_prices_request.count is 'Number of requested items, default - 10';

