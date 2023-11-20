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
create type deribit.public_get_index_price_request_index_name as enum ('ethdvol_usdc', 'btc_usdc', 'near_usd', 'dot_usd', 'algo_usdc', 'btcdvol_usdc', 'link_usdc', 'eth_usdc', 'shib_usd', 'sol_usdc', 'doge_usd', 'bch_usdc', 'btc_usd', 'usdc_usd', 'avax_usd', 'matic_usdc', 'near_usdc', 'xrp_usd', 'sol_usd', 'trx_usdc', 'algo_usd', 'xrp_usdc', 'matic_usd', 'dot_usdc', 'ltc_usd', 'link_usd', 'trx_usd', 'uni_usd', 'avax_usdc', 'ltc_usdc', 'shib_usdc', 'ada_usd', 'eth_usd', 'doge_usdc', 'uni_usdc', 'ada_usdc', 'bch_usd');

drop type if exists deribit.public_get_index_price_request cascade;
create type deribit.public_get_index_price_request as (
	index_name deribit.public_get_index_price_request_index_name
);
comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

