create type deribit.private_cancel_all_request as (
	detailed boolean
);
comment on column deribit.private_cancel_all_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';

create or replace function deribit.private_cancel_all_request_builder(
	detailed boolean default null
)
returns deribit.private_cancel_all_request
language plpgsql
as $$
begin
	return row(
		detailed
	)::deribit.private_cancel_all_request;
end;
$$;


create type deribit.private_cancel_all_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_response.result is 'Total number of successfully cancelled orders';

create or replace function deribit.private_cancel_all(params deribit.private_cancel_all_request)
returns deribit.private_cancel_all_response
language plpgsql
as $$
declare
	ret deribit.private_cancel_all_response;
begin
	with request as (
		select json_build_object(
			'method', '/private/cancel_all',
			'params', jsonb_strip_nulls(to_jsonb(params)),
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
				'/private/cancel_all' as end_point
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
		i.*
	into
		ret
	from exec
	cross join lateral jsonb_populate_record(null::deribit.private_cancel_all_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_cancel_all is 'This method cancels all users orders and trigger orders within all currencies and instrument kinds.';

