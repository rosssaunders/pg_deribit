drop type if exists deribit.public_get_index_price_response_result cascade;
create type deribit.public_get_index_price_response_result as (
	estimated_delivery_price double precision,
	index_price double precision
);
comment on column deribit.public_get_index_price_response_result.estimated_delivery_price is 'Estimated delivery price for the market. For more details, see Documentation > General > Expiration Price';
comment on column deribit.public_get_index_price_response_result.index_price is 'Value of requested index';

drop type if exists deribit.public_get_index_price_response cascade;
create type deribit.public_get_index_price_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_index_price_response_result
);
comment on column deribit.public_get_index_price_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_index_price_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_index_price_request_index_name cascade;
create type deribit.public_get_index_price_request_index_name as enum ('ada_usd', 'ada_usdc', 'algo_usd', 'algo_usdc', 'avax_usd', 'avax_usdc', 'bch_usd', 'bch_usdc', 'btc_usd', 'btc_usdc', 'btcdvol_usdc', 'doge_usd', 'doge_usdc', 'dot_usd', 'dot_usdc', 'eth_usd', 'eth_usdc', 'ethdvol_usdc', 'link_usd', 'link_usdc', 'ltc_usd', 'ltc_usdc', 'matic_usd', 'matic_usdc', 'near_usd', 'near_usdc', 'shib_usd', 'shib_usdc', 'sol_usd', 'sol_usdc', 'trx_usd', 'trx_usdc', 'uni_usd', 'uni_usdc', 'usdc_usd', 'xrp_usd', 'xrp_usdc');

drop type if exists deribit.public_get_index_price_request cascade;
create type deribit.public_get_index_price_request as (
	index_name deribit.public_get_index_price_request_index_name
);
comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

