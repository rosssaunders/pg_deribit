-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION deribit" to load this file. \quit

create schema deribit;

create type deribit.error as (
    code int,
    message text,
    data json
);

create type deribit.error_response as (
    usIn bigint,
    usOut bigint,
    usDiff int,
    jsonrpc text,
    testnet bool,
    error deribit.error
);

create sequence deribit.jsonrpc_identifier;

select nextval('deribit.jsonrpc_identifier'::regclass);

drop function deribit.jsonrpc_request;

create or replace function deribit.jsonrpc_request(url text, request anyelement)
returns omni_httpc.http_response
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_error_response deribit.error_response;
begin

    with jsonrpc as (
        select json_build_object(
            'method', url,
            'params', case when request is distinct from null then jsonb_strip_nulls(to_jsonb(request)) end,
            'jsonrpc', '2.0',
            'id', nextval('deribit.jsonrpc_identifier'::regclass)
        ) as payload
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
                url as end_point
        ) as a
    )
    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from jsonrpc
    cross join auth
    cross join url
    cross join omni_httpc.http_execute(
        omni_httpc.http_request(
            method := 'POST',
            url := url.url,
            body := jsonrpc.payload::text::bytea,
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

    return _http_response;

    end;
$$;

comment on function deribit.jsonrpc_request is 'Deribit extension internal function.';

drop function if exists deribit.jsonrpc_request_test(text, deribit.private_buy_request);
drop function if exists deribit.jsonrpc_request_test(text, anyelement);

create or replace function deribit.jsonrpc_request_test(url text, _request deribit.private_buy_request)
returns json
language plpgsql
as $$
begin
    return case when _request is distinct from null then json_strip_nulls(to_json(_request)) end;
    return case when _request is null then json_strip_nulls(to_json(_request)) end;
end
$$;


select deribit.jsonrpc_request_test('/private/buy', null);

select deribit.jsonrpc_request_test('/private/buy', row(
		'ETH-PERPETUAL',
		10,
		'market',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null
    )::deribit.private_buy_request);