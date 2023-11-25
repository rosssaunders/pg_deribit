drop type if exists deribit.private_get_mmp_config_response_result cascade;
create type deribit.private_get_mmp_config_response_result as (
	delta_limit float,
	frozen_time bigint,
	index_name text,
	"interval" bigint,
	quantity_limit float
);
comment on column deribit.private_get_mmp_config_response_result.delta_limit is 'Delta limit';
comment on column deribit.private_get_mmp_config_response_result.frozen_time is 'MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_get_mmp_config_response_result.index_name is 'Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.private_get_mmp_config_response_result."interval" is 'MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_get_mmp_config_response_result.quantity_limit is 'Quantity limit';

drop type if exists deribit.private_get_mmp_config_response cascade;
create type deribit.private_get_mmp_config_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_mmp_config_response_result[]
);
comment on column deribit.private_get_mmp_config_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_mmp_config_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_get_mmp_config_request_index_name cascade;
create type deribit.private_get_mmp_config_request_index_name as enum ('btc_usd', 'link_usdc', 'eth_usdc', 'btcdvol_usdc', 'uni_usdc', 'avax_usdc', 'shib_usdc', 'mshib_usdc', 'btc_usdc', 'algo_usdc', 'ada_usdc', 'near_usdc', 'xrp_usdc', 'ethdvol_usdc', 'luna_usdc', 'trx_usdc', 'dot_usdc', 'matic_usdc', 'bnb_usdc', 'ltc_usdc', 'doge_usdc', 'bch_usdc', 'eth_usd');

drop type if exists deribit.private_get_mmp_config_request cascade;
create type deribit.private_get_mmp_config_request as (
	index_name deribit.private_get_mmp_config_request_index_name
);
comment on column deribit.private_get_mmp_config_request.index_name is 'Index identifier of derivative instrument on the platform; skipping this parameter will return all configurations';

