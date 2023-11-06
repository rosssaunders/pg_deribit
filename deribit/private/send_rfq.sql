create type deribit.private_send_rfq_request_side as enum ('buy', 'sell');

create type deribit.private_send_rfq_request as (
	instrument_name text,
	amount float,
	side deribit.private_send_rfq_request_side
);
comment on column deribit.private_send_rfq_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_send_rfq_request.amount is 'Amount';
comment on column deribit.private_send_rfq_request.side is 'Side - buy or sell';

create or replace function deribit.private_send_rfq_request_builder(
	instrument_name text,
	amount float default null,
	side deribit.private_send_rfq_request_side default null
)
returns deribit.private_send_rfq_request
language plpgsql
as $$
begin
	return row(
		instrument_name,
		amount,
		side
	)::deribit.private_send_rfq_request;
end;
$$;


create type deribit.private_send_rfq_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_send_rfq_response.id is 'The id that was sent in the request';
comment on column deribit.private_send_rfq_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_send_rfq_response.result is 'Result of method execution. ok in case of success';

create or replace function deribit.private_send_rfq(params deribit.private_send_rfq_request)
returns deribit.private_send_rfq_response
language plpgsql
as $$
declare
	ret deribit.private_send_rfq_response;
begin
	with request as (
		select json_build_object(
			'method', '/private/send_rfq',
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
				'/private/send_rfq' as end_point
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
	cross join lateral jsonb_populate_record(null::deribit.private_send_rfq_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';

