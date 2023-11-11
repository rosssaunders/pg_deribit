create type deribit.private_set_mmp_config_False as (
	delta_limit float,
	frozen_time bigint,
	index_name text,
	interval bigint,
	quantity_limit float
);
comment on column deribit.private_set_mmp_config_False.delta_limit is 'Delta limit';
comment on column deribit.private_set_mmp_config_False.frozen_time is 'MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_set_mmp_config_False.index_name is 'Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.private_set_mmp_config_False.interval is 'MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_set_mmp_config_False.quantity_limit is 'Quantity limit';

create type deribit.private_set_mmp_config_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_set_mmp_config_False[]
);
comment on column deribit.private_set_mmp_config_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_mmp_config_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_set_mmp_config_request_index_name as enum ('btc_usd', 'eth_usd', 'btc_usdc', 'eth_usdc', 'ada_usdc', 'algo_usdc', 'avax_usdc', 'bch_usdc', 'bnb_usdc', 'doge_usdc', 'dot_usdc', 'link_usdc', 'ltc_usdc', 'luna_usdc', 'matic_usdc', 'mshib_usdc', 'near_usdc', 'shib_usdc', 'trx_usdc', 'uni_usdc', 'xrp_usdc', 'btcdvol_usdc', 'ethdvol_usdc');

create type deribit.private_set_mmp_config_request as (
	index_name deribit.private_set_mmp_config_request_index_name,
	interval bigint,
	frozen_time bigint,
	quantity_limit float,
	delta_limit float
);
comment on column deribit.private_set_mmp_config_request.index_name is '(Required) Index identifier of derivative instrument on the platform';
comment on column deribit.private_set_mmp_config_request.interval is '(Required) MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_set_mmp_config_request.frozen_time is '(Required) MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_set_mmp_config_request.quantity_limit is 'Quantity limit';
comment on column deribit.private_set_mmp_config_request.delta_limit is 'Delta limit';

create or replace function deribit.private_set_mmp_config(
	index_name deribit.private_set_mmp_config_request_index_name,
	interval bigint,
	frozen_time bigint,
	quantity_limit float default null,
	delta_limit float default null
)
returns deribit.private_set_mmp_config_response
language plpgsql
as $$
declare
	_request deribit.private_set_mmp_config_request;
	_response deribit.private_set_mmp_config_response;
begin
	_request := row(
		index_name,
		interval,
		frozen_time,
		quantity_limit,
		delta_limit
	)::deribit.private_set_mmp_config_request;

	with request as (
		select json_build_object(
			'method', '/private/set_mmp_config',
			'params', jsonb_strip_nulls(to_jsonb(_request)),
			'jsonrpc', '2.0',
			'id', 3
		) as request
	),
	auth as (
		select
			'Authorization' as key,
			'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value
	),
	url as (
		select format('%s%s', base_url, end_point) as url
		from
		(
			select
				'https://test.deribit.com/api/v2' as base_url,
				'/private/set_mmp_config' as end_point
		) as a
	),
	exec as (
		select
			version,
			status,
			headers,
			body,
			error
		from request
		cross join auth
		cross join url
		cross join omni_httpc.http_execute(
			omni_httpc.http_request(
				method := 'POST',
				url := url.url,
				body := request.request::text::bytea,
				headers := array[row (auth.key, auth.value)::omni_http.http_header])
		) as response
	)
	select
		i.id,
		i.jsonrpc,
		i.result
	into
		_response
	from exec
	cross join lateral jsonb_populate_record(null::deribit.private_set_mmp_config_response, convert_from(body, 'utf-8')::jsonb) i;

	return _response;
end;
$$;
comment on function deribit.private_set_mmp_config is 'Set config for MMP - triggers MMP reset';

