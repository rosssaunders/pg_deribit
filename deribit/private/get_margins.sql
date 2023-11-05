create type deribit.private_get_margins_request as (
	instrument_name text,
	amount float,
	price float
);
comment on column deribit.private_get_margins_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_get_margins_request.amount is '(Required) Amount, integer for future, float for option. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_margins_request.price is '(Required) Price';

create or replace function deribit.private_get_margins_request_builder(
	instrument_name text,
	amount float,
	price float
)
returns deribit.private_get_margins_request
language plpgsql
as $$
begin
	return row(
		instrument_name,
		amount,
		price
	)::deribit.private_get_margins_request;
end;
$$;


create type deribit.private_get_margins_result as (
	buy float,
	max_price float,
	min_price float,
	sell float
);
comment on column deribit.private_get_margins_result.buy is 'Margin when buying';
comment on column deribit.private_get_margins_result.max_price is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.private_get_margins_result.min_price is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.private_get_margins_result.sell is 'Margin when selling';

create type deribit.private_get_margins_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_margins_result
);
comment on column deribit.private_get_margins_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_margins_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_margins(params deribit.private_get_margins_request)
returns record
language plpgsql
as $$
declare
	ret record;
begin
	with request as (
		select json_build_object(
			'method', '/private/get_margins',
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
				'/private/get_margins' as end_point
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
	cross join lateral jsonb_populate_record(null::deribit.private_get_margins_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_get_margins is 'Get margins for given instrument, amount and price.';

