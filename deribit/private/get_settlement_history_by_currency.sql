create type deribit.private_get_settlement_history_by_currency_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_settlement_history_by_currency_request_type as enum ('settlement', 'delivery', 'bankruptcy');

create type deribit.private_get_settlement_history_by_currency_request as (
	currency deribit.private_get_settlement_history_by_currency_request_currency,
	type deribit.private_get_settlement_history_by_currency_request_type,
	count bigint,
	continuation text,
	search_start_timestamp bigint
);
comment on column deribit.private_get_settlement_history_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_settlement_history_by_currency_request.type is 'Settlement type';
comment on column deribit.private_get_settlement_history_by_currency_request.count is 'Number of requested items, default - 20';
comment on column deribit.private_get_settlement_history_by_currency_request.continuation is 'Continuation token for pagination';
comment on column deribit.private_get_settlement_history_by_currency_request.search_start_timestamp is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create or replace function deribit.private_get_settlement_history_by_currency_request_builder(
	currency deribit.private_get_settlement_history_by_currency_request_currency,
	type deribit.private_get_settlement_history_by_currency_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.private_get_settlement_history_by_currency_request
language plpgsql
as $$
begin
	return row(
		currency,
		type,
		count,
		continuation,
		search_start_timestamp
	)::deribit.private_get_settlement_history_by_currency_request;
end;
$$;


create type deribit.private_get_settlement_history_by_currency_settlement as (
	funded float,
	funding float,
	index_price float,
	instrument_name text,
	mark_price float,
	position float,
	profit_loss float,
	session_bankrupcy float,
	session_profit_loss float,
	session_tax float,
	session_tax_rate float,
	socialized float,
	timestamp bigint,
	type text
);
comment on column deribit.private_get_settlement_history_by_currency_settlement.funded is 'funded amount (bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.funding is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.index_price is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.instrument_name is 'instrument name (settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.mark_price is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.position is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.profit_loss is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.session_bankrupcy is 'value of session bankrupcy (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.session_profit_loss is 'total value of session profit and losses (in base currency)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.session_tax is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.session_tax_rate is 'rate of paid texes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.socialized is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_settlement_history_by_currency_settlement.type is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.private_get_settlement_history_by_currency_result as (
	continuation text
);
comment on column deribit.private_get_settlement_history_by_currency_result.continuation is 'Continuation token for pagination.';

create type deribit.private_get_settlement_history_by_currency_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_settlement_history_by_currency_result,
	settlements deribit.private_get_settlement_history_by_currency_settlement[]
);
comment on column deribit.private_get_settlement_history_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_settlement_history_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_settlement_history_by_currency(params deribit.private_get_settlement_history_by_currency_request)
returns record
language plpgsql
as $$
declare
	ret record;
begin
	with request as (
		select json_build_object(
			'method', '/private/get_settlement_history_by_currency',
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
				'/private/get_settlement_history_by_currency' as end_point
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
	cross join lateral jsonb_populate_record(null::deribit.private_get_settlement_history_by_currency_response, convert_from(body, 'utf-8')::jsonb) i;
	return ret;
end;
$$;
comment on function deribit.private_get_settlement_history_by_currency is 'Retrieves settlement, delivery and bankruptcy events that have affected your account.';

