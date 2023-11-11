create type deribit.private_get_deposits_response_datum as (
	address text,
	amount float,
	currency text,
	received_timestamp bigint,
	state text,
	transaction_id text,
	updated_timestamp bigint
);
comment on column deribit.private_get_deposits_response_datum.address is 'Address in proper format for currency';
comment on column deribit.private_get_deposits_response_datum.amount is 'Amount of funds in given currency';
comment on column deribit.private_get_deposits_response_datum.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_deposits_response_datum.received_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_deposits_response_datum.state is 'Deposit state, allowed values : pending, completed, rejected, replaced';
comment on column deribit.private_get_deposits_response_datum.transaction_id is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_get_deposits_response_datum.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_deposits_response_result as (
	count bigint
);
comment on column deribit.private_get_deposits_response_result.count is 'Total number of results available';

create type deribit.private_get_deposits_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_deposits_response_result,
	data deribit.private_get_deposits_response_datum[]
);
comment on column deribit.private_get_deposits_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_deposits_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_deposits_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_deposits_request as (
	currency deribit.private_get_deposits_request_currency,
	count bigint,
	"offset" bigint
);
comment on column deribit.private_get_deposits_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_deposits_request.count is 'Number of requested items, default - 10';
comment on column deribit.private_get_deposits_request."offset" is 'The offset for pagination, default - 0';

create or replace function deribit.private_get_deposits(
	currency deribit.private_get_deposits_request_currency,
	count bigint default null,
	"offset" bigint default null
)
returns deribit.private_get_deposits_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_deposits_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		count,
		"offset"
    )::deribit.private_get_deposits_request;

    with request as (
        select json_build_object(
            'method', '/private/get_deposits',
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
                '/private/get_deposits' as end_point
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
        null::deribit.private_get_deposits_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_deposits is 'Retrieve the latest users deposits';

