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
create type deribit.public_get_delivery_prices_request_index_name as enum ('btc_usd', 'algo_usd', 'link_usdc', 'bch_usdc', 'trx_usd', 'matic_usdc', 'doge_usdc', 'sol_usd', 'ada_usd', 'shib_usd', 'dot_usdc', 'ltc_usd', 'matic_usd', 'trx_usdc', 'bch_usd', 'uni_usd', 'btcdvol_usdc', 'ethdvol_usdc', 'ltc_usdc', 'near_usd', 'eth_usd', 'avax_usdc', 'ada_usdc', 'usdc_usd', 'dot_usd', 'xrp_usd', 'eth_usdc', 'btc_usdc', 'avax_usd', 'doge_usd', 'near_usdc', 'xrp_usdc', 'shib_usdc', 'algo_usdc', 'sol_usdc', 'link_usd', 'uni_usdc');

drop type if exists deribit.public_get_delivery_prices_request cascade;
create type deribit.public_get_delivery_prices_request as (
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint,
	count bigint
);
comment on column deribit.public_get_delivery_prices_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.public_get_delivery_prices_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.public_get_delivery_prices_request.count is 'Number of requested items, default - 10';

