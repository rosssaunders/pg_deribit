create type deribit.private_get_settlement_history_by_instrument_response_settlement as (
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
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.funded is 'funded amount (bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.funding is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.index_price is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.instrument_name is 'instrument name (settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.mark_price is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.position is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.profit_loss is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_bankrupcy is 'value of session bankrupcy (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_profit_loss is 'total value of session profit and losses (in base currency)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_tax is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_tax_rate is 'rate of paid texes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.socialized is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.type is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.private_get_settlement_history_by_instrument_response_result as (
	continuation text,
	settlements deribit.private_get_settlement_history_by_instrument_response_settlement[]
);
comment on column deribit.private_get_settlement_history_by_instrument_response_result.continuation is 'Continuation token for pagination.';

create type deribit.private_get_settlement_history_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_settlement_history_by_instrument_response_result
);
comment on column deribit.private_get_settlement_history_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_settlement_history_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_settlement_history_by_instrument_request_type as enum ('settlement', 'delivery', 'bankruptcy');

create type deribit.private_get_settlement_history_by_instrument_request as (
	instrument_name text,
	type deribit.private_get_settlement_history_by_instrument_request_type,
	count bigint,
	continuation text,
	search_start_timestamp bigint
);
comment on column deribit.private_get_settlement_history_by_instrument_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_get_settlement_history_by_instrument_request.type is 'Settlement type';
comment on column deribit.private_get_settlement_history_by_instrument_request.count is 'Number of requested items, default - 20';
comment on column deribit.private_get_settlement_history_by_instrument_request.continuation is 'Continuation token for pagination';
comment on column deribit.private_get_settlement_history_by_instrument_request.search_start_timestamp is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create or replace function deribit.private_get_settlement_history_by_instrument(
	instrument_name text,
	type deribit.private_get_settlement_history_by_instrument_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.private_get_settlement_history_by_instrument_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_settlement_history_by_instrument_request;
    _error_response deribit.error_response;
begin
    _request := row(
		instrument_name,
		type,
		count,
		continuation,
		search_start_timestamp
    )::deribit.private_get_settlement_history_by_instrument_request;

    with request as (
        select json_build_object(
            'method', '/private/get_settlement_history_by_instrument',
            'params', jsonb_strip_nulls(to_jsonb(_request)),
            'jsonrpc', '2.0',
            'id', nextval('deribit.jsonrpc_identifier'::regclass)
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
                '/private/get_settlement_history_by_instrument' as end_point
        ) as a
    )
    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
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
    limit 1;
    
    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
             case
                when (_error_response.error).data is null then ''
                 else ':' || (_error_response.error).data
             end;
    end if;
    
    return (jsonb_populate_record(
        null::deribit.private_get_settlement_history_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_settlement_history_by_instrument is 'Retrieves public settlement, delivery and bankruptcy events filtered by instrument name';

