create type deribit.private_cancel_all_by_instrument_request_type as enum ('all', 'limit', 'trigger_all', 'stop', 'take', 'trailing_stop');

create type deribit.private_cancel_all_by_instrument_request as (
	instrument_name text,
	type deribit.private_cancel_all_by_instrument_request_type,
	detailed boolean,
	include_combos boolean
);
comment on column deribit.private_cancel_all_by_instrument_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_cancel_all_by_instrument_request.type is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_instrument_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_by_instrument_request.include_combos is 'When set to true orders in combo instruments affecting given position will also be cancelled. Default: false';

create or replace function deribit.private_cancel_all_by_instrument_request_builder(
	instrument_name text,
	type deribit.private_cancel_all_by_instrument_request_type default null,
	detailed boolean default null,
	include_combos boolean default null
)
returns deribit.private_cancel_all_by_instrument_request
language plpgsql
as $$
begin
	return row(
		instrument_name,
		type,
		detailed,
		include_combos
	)::deribit.private_cancel_all_by_instrument_request;
end;
$$;


create type deribit.private_cancel_all_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_instrument_response.result is 'Total number of successfully cancelled orders';

create or replace function deribit.private_cancel_all_by_instrument(params deribit.private_cancel_all_by_instrument_request)
returns record
language plpgsql
as $$
declare
	ret record;
begin
	with request as (
		select json_build_object(
			'method', '/private/cancel_all_by_instrument',
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
				'/private/cancel_all_by_instrument' as end_point
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
	cross join lateral jsonb_populate_record(null::deribit.private_cancel_all_by_instrument_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_cancel_all_by_instrument is 'Cancels all orders by instrument, optionally filtered by order type.';

