create type deribit.private_reset_mmp_request_index_name as enum ('btc_usd', 'eth_usd', 'btc_usdc', 'eth_usdc', 'ada_usdc', 'algo_usdc', 'avax_usdc', 'bch_usdc', 'bnb_usdc', 'doge_usdc', 'dot_usdc', 'link_usdc', 'ltc_usdc', 'luna_usdc', 'matic_usdc', 'mshib_usdc', 'near_usdc', 'shib_usdc', 'trx_usdc', 'uni_usdc', 'xrp_usdc', 'btcdvol_usdc', 'ethdvol_usdc');

create type deribit.private_reset_mmp_request as (
	index_name deribit.private_reset_mmp_request_index_name
);
comment on column deribit.private_reset_mmp_request.index_name is '(Required) Index identifier of derivative instrument on the platform';

create or replace function deribit.private_reset_mmp_request_builder(
	index_name deribit.private_reset_mmp_request_index_name
)
returns deribit.private_reset_mmp_request
language plpgsql
as $$
begin
	return row(
		index_name
	)::deribit.private_reset_mmp_request;
end;
$$;


create type deribit.private_reset_mmp_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_reset_mmp_response.id is 'The id that was sent in the request';
comment on column deribit.private_reset_mmp_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_reset_mmp_response.result is 'Result of method execution. ok in case of success';

create or replace function deribit.private_reset_mmp(params deribit.private_reset_mmp_request)
returns record
language plpgsql
as $$
declare
	ret record;
begin
	with request as (
		select json_build_object(
			'method', '/private/reset_mmp',
			'params', jsonb_strip_nulls(to_jsonb(params)),
			'jsonrpc', '2.0',
			'id', 3
		) as request
	),
	auth as (
		select
			'Authorization' as key,
			'Basic ' || encode(('<CLIENT_ID>' || ':' || '<CLIENT_TOKEN>')::bytea, 'base64') as value
	),
	url as (
		select format('%s%s', base_url, end_point) as url
		from
		(
			select
				'https://test.deribit.com/api/v2' as base_url,
				'/private/reset_mmp' as end_point
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
		exec.*,
		i.*
	into
		ret
	from exec
	cross join lateral jsonb_populate_record(null::deribit.private_reset_mmp_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_reset_mmp is 'Reset MMP';

