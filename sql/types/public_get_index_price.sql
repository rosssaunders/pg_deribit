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
create type deribit.public_get_index_price_request_index_name as enum ('btc_usd', 'sol_usd', 'link_usdc', 'usdc_usd', 'shib_usd', 'eth_usdc', 'avax_usd', 'btcdvol_usdc', 'uni_usdc', 'avax_usdc', 'shib_usdc', 'btc_usdc', 'algo_usdc', 'link_usd', 'bch_usd', 'dot_usd', 'ada_usdc', 'near_usdc', 'xrp_usd', 'ltc_usd', 'sol_usdc', 'xrp_usdc', 'doge_usd', 'matic_usd', 'algo_usd', 'ethdvol_usdc', 'trx_usd', 'trx_usdc', 'dot_usdc', 'matic_usdc', 'ada_usd', 'ltc_usdc', 'uni_usd', 'doge_usdc', 'bch_usdc', 'eth_usd', 'near_usd');

drop type if exists deribit.public_get_index_price_request cascade;
create type deribit.public_get_index_price_request as (
	index_name deribit.public_get_index_price_request_index_name
);
comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

