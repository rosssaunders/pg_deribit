create type deribit.private_get_order_margin_by_ids_request as (
	ids text[]
);
comment on column deribit.private_get_order_margin_by_ids_request.ids is '(Required) Ids of orders';

create or replace function deribit.private_get_order_margin_by_ids_request_builder(
	ids text[]
)
returns deribit.private_get_order_margin_by_ids_request
language plpgsql
as $$
begin
	return row(
		ids
	)::deribit.private_get_order_margin_by_ids_request;
end;
$$;


create type deribit.private_get_order_margin_by_ids_False as (
	initial_margin float,
	initial_margin_currency text,
	order_id text
);
comment on column deribit.private_get_order_margin_by_ids_False.initial_margin is 'Initial margin of order';
comment on column deribit.private_get_order_margin_by_ids_False.initial_margin_currency is 'Currency of initial margin';
comment on column deribit.private_get_order_margin_by_ids_False.order_id is 'Unique order identifier';

create type deribit.private_get_order_margin_by_ids_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_order_margin_by_ids_False[]
);
comment on column deribit.private_get_order_margin_by_ids_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_order_margin_by_ids_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_order_margin_by_ids(params deribit.private_get_order_margin_by_ids_request)
returns deribit.private_get_order_margin_by_ids_response
language plpgsql
as $$
declare
	ret deribit.private_get_order_margin_by_ids_response;
begin
	with request as (
		select json_build_object(
			'method', '/private/get_order_margin_by_ids',
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
				'/private/get_order_margin_by_ids' as end_point
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
	cross join lateral jsonb_populate_record(null::deribit.private_get_order_margin_by_ids_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_get_order_margin_by_ids is 'Retrieves initial margins of given orders';

