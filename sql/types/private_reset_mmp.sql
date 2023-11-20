drop type if exists deribit.private_reset_mmp_response cascade;
create type deribit.private_reset_mmp_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_reset_mmp_response.id is 'The id that was sent in the request';
comment on column deribit.private_reset_mmp_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_reset_mmp_response.result is 'Result of method execution. ok in case of success';

drop type if exists deribit.private_reset_mmp_request_index_name cascade;
create type deribit.private_reset_mmp_request_index_name as enum ('ethdvol_usdc', 'btc_usdc', 'algo_usdc', 'btcdvol_usdc', 'link_usdc', 'eth_usdc', 'bch_usdc', 'btc_usd', 'matic_usdc', 'near_usdc', 'trx_usdc', 'xrp_usdc', 'mshib_usdc', 'dot_usdc', 'bnb_usdc', 'avax_usdc', 'ltc_usdc', 'shib_usdc', 'eth_usd', 'luna_usdc', 'doge_usdc', 'uni_usdc', 'ada_usdc');

drop type if exists deribit.private_reset_mmp_request cascade;
create type deribit.private_reset_mmp_request as (
	index_name deribit.private_reset_mmp_request_index_name
);
comment on column deribit.private_reset_mmp_request.index_name is '(Required) Index identifier of derivative instrument on the platform';

