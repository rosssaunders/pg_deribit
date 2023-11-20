drop type if exists deribit.private_set_mmp_config_response_result cascade;
create type deribit.private_set_mmp_config_response_result as (
	delta_limit float,
	frozen_time bigint,
	index_name text,
	"interval" bigint,
	quantity_limit float
);
comment on column deribit.private_set_mmp_config_response_result.delta_limit is 'Delta limit';
comment on column deribit.private_set_mmp_config_response_result.frozen_time is 'MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_set_mmp_config_response_result.index_name is 'Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.private_set_mmp_config_response_result."interval" is 'MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_set_mmp_config_response_result.quantity_limit is 'Quantity limit';

drop type if exists deribit.private_set_mmp_config_response cascade;
create type deribit.private_set_mmp_config_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_set_mmp_config_response_result[]
);
comment on column deribit.private_set_mmp_config_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_mmp_config_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_set_mmp_config_request_index_name cascade;
create type deribit.private_set_mmp_config_request_index_name as enum ('ethdvol_usdc', 'btc_usdc', 'algo_usdc', 'btcdvol_usdc', 'link_usdc', 'eth_usdc', 'bch_usdc', 'btc_usd', 'matic_usdc', 'near_usdc', 'trx_usdc', 'xrp_usdc', 'mshib_usdc', 'dot_usdc', 'bnb_usdc', 'avax_usdc', 'ltc_usdc', 'shib_usdc', 'eth_usd', 'luna_usdc', 'doge_usdc', 'uni_usdc', 'ada_usdc');

drop type if exists deribit.private_set_mmp_config_request cascade;
create type deribit.private_set_mmp_config_request as (
	index_name deribit.private_set_mmp_config_request_index_name,
	"interval" bigint,
	frozen_time bigint,
	quantity_limit float,
	delta_limit float
);
comment on column deribit.private_set_mmp_config_request.index_name is '(Required) Index identifier of derivative instrument on the platform';
comment on column deribit.private_set_mmp_config_request."interval" is '(Required) MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_set_mmp_config_request.frozen_time is '(Required) MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_set_mmp_config_request.quantity_limit is 'Quantity limit';
comment on column deribit.private_set_mmp_config_request.delta_limit is 'Delta limit';

