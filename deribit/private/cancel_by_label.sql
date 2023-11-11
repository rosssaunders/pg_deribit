create type deribit.private_cancel_by_label_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_by_label_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_by_label_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_by_label_response.result is 'Total number of successfully cancelled orders';

create type deribit.private_cancel_by_label_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_cancel_by_label_request as (
	label text,
	currency deribit.private_cancel_by_label_request_currency
);
comment on column deribit.private_cancel_by_label_request.label is '(Required) user defined label for the order (maximum 64 characters)';
comment on column deribit.private_cancel_by_label_request.currency is 'The currency symbol';

create or replace function deribit.private_cancel_by_label(
	label text,
	currency deribit.private_cancel_by_label_request_currency default null
)
returns deribit.private_cancel_by_label_response
language plpgsql
as $$
declare
	_request deribit.private_cancel_by_label_request;
	_response deribit.private_cancel_by_label_response;
begin
	_request := row(
		label,
		currency
	)::deribit.private_cancel_by_label_request;

	with request as (
		select json_build_object(
			'method', '/private/cancel_by_label',
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
				'/private/cancel_by_label' as end_point
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
	cross join lateral jsonb_populate_record(null::deribit.private_cancel_by_label_response, convert_from(body, 'utf-8')::jsonb) i;

	return _response;
end;
$$;
comment on function deribit.private_cancel_by_label is 'Cancels orders by label. All user''s orders (trigger orders too), with given label are canceled in all currencies or in one given currency (in this case currency queue is used) ';

