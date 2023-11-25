drop type if exists deribit.public_get_delivery_prices_response_datum cascade;
create type deribit.public_get_delivery_prices_response_datum as (
	date text,
	delivery_price double precision,
	records_total double precision
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
create type deribit.public_get_delivery_prices_request_index_name as enum ('ada_usd', 'ada_usdc', 'algo_usd', 'algo_usdc', 'avax_usd', 'avax_usdc', 'bch_usd', 'bch_usdc', 'btc_usd', 'btc_usdc', 'btcdvol_usdc', 'doge_usd', 'doge_usdc', 'dot_usd', 'dot_usdc', 'eth_usd', 'eth_usdc', 'ethdvol_usdc', 'link_usd', 'link_usdc', 'ltc_usd', 'ltc_usdc', 'matic_usd', 'matic_usdc', 'near_usd', 'near_usdc', 'shib_usd', 'shib_usdc', 'sol_usd', 'sol_usdc', 'trx_usd', 'trx_usdc', 'uni_usd', 'uni_usdc', 'usdc_usd', 'xrp_usd', 'xrp_usdc');

drop type if exists deribit.public_get_delivery_prices_request cascade;
create type deribit.public_get_delivery_prices_request as (
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint,
	count bigint
);
comment on column deribit.public_get_delivery_prices_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.public_get_delivery_prices_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.public_get_delivery_prices_request.count is 'Number of requested items, default - 10';

