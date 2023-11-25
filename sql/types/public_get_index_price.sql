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
create type deribit.public_get_index_price_request_index_name as enum ('btc_usd', 'algo_usd', 'link_usdc', 'bch_usdc', 'trx_usd', 'matic_usdc', 'doge_usdc', 'sol_usd', 'ada_usd', 'shib_usd', 'dot_usdc', 'ltc_usd', 'matic_usd', 'trx_usdc', 'bch_usd', 'uni_usd', 'btcdvol_usdc', 'ethdvol_usdc', 'ltc_usdc', 'near_usd', 'eth_usd', 'avax_usdc', 'ada_usdc', 'usdc_usd', 'dot_usd', 'xrp_usd', 'eth_usdc', 'btc_usdc', 'avax_usd', 'doge_usd', 'near_usdc', 'xrp_usdc', 'shib_usdc', 'algo_usdc', 'sol_usdc', 'link_usd', 'uni_usdc');

drop type if exists deribit.public_get_index_price_request cascade;
create type deribit.public_get_index_price_request as (
	index_name deribit.public_get_index_price_request_index_name
);
comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

