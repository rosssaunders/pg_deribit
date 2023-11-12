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

create type deribit.private_set_mmp_config_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_set_mmp_config_response_result[]
);
comment on column deribit.private_set_mmp_config_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_mmp_config_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_set_mmp_config_request_index_name as enum ('btc_usd', 'eth_usd', 'btc_usdc', 'eth_usdc', 'ada_usdc', 'algo_usdc', 'avax_usdc', 'bch_usdc', 'bnb_usdc', 'doge_usdc', 'dot_usdc', 'link_usdc', 'ltc_usdc', 'luna_usdc', 'matic_usdc', 'mshib_usdc', 'near_usdc', 'shib_usdc', 'trx_usdc', 'uni_usdc', 'xrp_usdc', 'btcdvol_usdc', 'ethdvol_usdc');

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

create or replace function deribit.private_set_mmp_config(
	index_name deribit.private_set_mmp_config_request_index_name,
	"interval" bigint,
	frozen_time bigint,
	quantity_limit float default null,
	delta_limit float default null
)
returns deribit.private_set_mmp_config_response_result
language plpgsql
as $$
declare
	_request deribit.private_set_mmp_config_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		index_name,
		"interval",
		frozen_time,
		quantity_limit,
		delta_limit
    )::deribit.private_set_mmp_config_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/set_mmp_config', _request));

    return (jsonb_populate_record(
        null::deribit.private_set_mmp_config_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_set_mmp_config is 'Set config for MMP - triggers MMP reset';

