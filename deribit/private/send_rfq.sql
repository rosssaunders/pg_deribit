create type deribit.private_send_rfq_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_send_rfq_response.id is 'The id that was sent in the request';
comment on column deribit.private_send_rfq_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_send_rfq_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_send_rfq_request_side as enum ('buy', 'sell');

create type deribit.private_send_rfq_request as (
	instrument_name text,
	amount float,
	side deribit.private_send_rfq_request_side
);
comment on column deribit.private_send_rfq_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_send_rfq_request.amount is 'Amount';
comment on column deribit.private_send_rfq_request.side is 'Side - buy or sell';

create or replace function deribit.private_send_rfq(
	instrument_name text,
	amount float default null,
	side deribit.private_send_rfq_request_side default null
)
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_send_rfq_request;
    _error_response deribit.error_response;
begin
    _request := row(
		instrument_name,
		amount,
		side
    )::deribit.private_send_rfq_request;

    with request as (
        select json_build_object(
            'method', '/private/send_rfq',
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
                '/private/send_rfq' as end_point
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
        null::deribit.private_send_rfq_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';

