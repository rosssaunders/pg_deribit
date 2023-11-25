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
create type deribit.private_reset_mmp_request_index_name as enum ('btc_usd', 'link_usdc', 'eth_usdc', 'btcdvol_usdc', 'uni_usdc', 'avax_usdc', 'shib_usdc', 'mshib_usdc', 'btc_usdc', 'algo_usdc', 'ada_usdc', 'near_usdc', 'xrp_usdc', 'ethdvol_usdc', 'luna_usdc', 'trx_usdc', 'dot_usdc', 'matic_usdc', 'bnb_usdc', 'ltc_usdc', 'doge_usdc', 'bch_usdc', 'eth_usd');

drop type if exists deribit.private_reset_mmp_request cascade;
create type deribit.private_reset_mmp_request as (
	index_name deribit.private_reset_mmp_request_index_name
);
comment on column deribit.private_reset_mmp_request.index_name is '(Required) Index identifier of derivative instrument on the platform';

