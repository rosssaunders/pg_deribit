create type deribit.private_cancel_all_by_kind_or_type_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_by_kind_or_type_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_kind_or_type_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_kind_or_type_response.result is 'Total number of successfully cancelled orders';

create type deribit.private_cancel_all_by_kind_or_type_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo', 'combo', 'any');

create type deribit.private_cancel_all_by_kind_or_type_request_type as enum ('all', 'limit', 'trigger_all', 'stop', 'take', 'trailing_stop');

create type deribit.private_cancel_all_by_kind_or_type_request as (
	currency UNKNOWN - string or array of strings,
	kind deribit.private_cancel_all_by_kind_or_type_request_kind,
	type deribit.private_cancel_all_by_kind_or_type_request_type,
	detailed boolean
);
comment on column deribit.private_cancel_all_by_kind_or_type_request.currency is '(Required) The currency symbol, list of currency symbols or "any" for all';
comment on column deribit.private_cancel_all_by_kind_or_type_request.kind is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_all_by_kind_or_type_request.type is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_kind_or_type_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';

create or replace function deribit.private_cancel_all_by_kind_or_type(
	currency UNKNOWN - string or array of strings,
	kind deribit.private_cancel_all_by_kind_or_type_request_kind default null,
	type deribit.private_cancel_all_by_kind_or_type_request_type default null,
	detailed boolean default null
)
returns deribit.private_cancel_all_by_kind_or_type_response
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_cancel_all_by_kind_or_type_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		kind,
		type,
		detailed
    )::deribit.private_cancel_all_by_kind_or_type_request;

    with request as (
        select json_build_object(
            'method', '/private/cancel_all_by_kind_or_type',
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
                '/private/cancel_all_by_kind_or_type' as end_point
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
        null::deribit.private_cancel_all_by_kind_or_type_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_cancel_all_by_kind_or_type is 'Cancels all orders in currency(currencies), optionally filtered by instrument kind and/or order type.';

