create type deribit.private_get_margins_response_result as (
	buy float,
	max_price float,
	min_price float,
	sell float
);
comment on column deribit.private_get_margins_response_result.buy is 'Margin when buying';
comment on column deribit.private_get_margins_response_result.max_price is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.private_get_margins_response_result.min_price is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.private_get_margins_response_result.sell is 'Margin when selling';

create type deribit.private_get_margins_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_margins_response_result
);
comment on column deribit.private_get_margins_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_margins_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_margins_request as (
	instrument_name text,
	amount float,
	price float
);
comment on column deribit.private_get_margins_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_get_margins_request.amount is '(Required) Amount, integer for future, float for option. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_margins_request.price is '(Required) Price';

create or replace function deribit.private_get_margins(
	instrument_name text,
	amount float,
	price float
)
returns deribit.private_get_margins_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_margins_request;
    _error_response deribit.error_response;
begin
    _request := row(
		instrument_name,
		amount,
		price
    )::deribit.private_get_margins_request;

    with request as (
        select json_build_object(
            'method', '/private/get_margins',
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
                '/private/get_margins' as end_point
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
        null::deribit.private_get_margins_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_margins is 'Get margins for given instrument, amount and price.';

