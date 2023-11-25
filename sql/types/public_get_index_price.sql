drop type if exists deribit.public_get_index_price_response_result cascade;
create type deribit.public_get_index_price_response_result as (
	estimated_delivery_price float,
	index_price float
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
create type deribit.public_get_index_price_request_index_name as enum ('near_usd', 'algo_usd', 'btcdvol_usdc', 'dot_usdc', 'avax_usdc', 'usdc_usd', 'sol_usdc', 'algo_usdc', 'matic_usd', 'xrp_usd', 'ltc_usdc', 'matic_usdc', 'doge_usdc', 'ada_usdc', 'link_usdc', 'avax_usd', 'ltc_usd', 'bch_usdc', 'near_usdc', 'trx_usdc', 'ada_usd', 'doge_usd', 'shib_usd', 'link_usd', 'btc_usdc', 'shib_usdc', 'uni_usdc', 'dot_usd', 'btc_usd', 'bch_usd', 'sol_usd', 'trx_usd', 'eth_usdc', 'eth_usd', 'xrp_usdc', 'uni_usd', 'ethdvol_usdc');

drop type if exists deribit.public_get_index_price_request cascade;
create type deribit.public_get_index_price_request as (
	index_name deribit.public_get_index_price_request_index_name
);
comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

