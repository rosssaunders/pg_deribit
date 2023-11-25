drop type if exists deribit.private_get_mmp_config_response_result cascade;
create type deribit.private_get_mmp_config_response_result as (
	delta_limit double precision,
	frozen_time bigint,
	index_name text,
	"interval" bigint,
	quantity_limit double precision
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
create type deribit.private_get_mmp_config_request_index_name as enum ('btc_usd', 'link_usdc', 'bch_usdc', 'bnb_usdc', 'luna_usdc', 'matic_usdc', 'doge_usdc', 'mshib_usdc', 'dot_usdc', 'trx_usdc', 'btcdvol_usdc', 'ethdvol_usdc', 'ltc_usdc', 'eth_usd', 'avax_usdc', 'ada_usdc', 'eth_usdc', 'btc_usdc', 'near_usdc', 'xrp_usdc', 'shib_usdc', 'algo_usdc', 'uni_usdc');

drop type if exists deribit.private_get_mmp_config_request cascade;
create type deribit.private_get_mmp_config_request as (
	index_name deribit.private_get_mmp_config_request_index_name
);
comment on column deribit.private_get_mmp_config_request.index_name is 'Index identifier of derivative instrument on the platform; skipping this parameter will return all configurations';

