-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION deribit" to load this file. \quit

create schema deribit;

create type deribit.internal_error as (
    code int,
    message text,
    data json
);

create type deribit.internal_error_response as (
    usIn bigint,
    usOut bigint,
    usDiff int,
    jsonrpc text,
    testnet bool,
    error deribit.internal_error
);

create sequence deribit.internal_jsonrpc_identifier;

create table deribit.internal_endpoint_rate_limit (key text primary key, last_call timestamptz, calls int, time_waiting interval);

select pg_catalog.pg_extension_config_dump('deribit.internal_endpoint_rate_limit', '');

create or replace function deribit.internal_build_auth_headers()
returns omni_http.http_header
language sql
as $$
    select (
        'Authorization',
        'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64')
    )::omni_http.http_header
    limit 1
$$;

create or replace function deribit.internal_url_endpoint(url text)
returns text
language sql
as $$
    select format('%s%s', base_url, end_point) as url
    from
    (
        select
            'https://test.deribit.com/api/v2' as base_url,
            url as end_point
    ) as a
    limit 1
$$;

create or replace function deribit.internal_jsonrpc_request(url text)
returns omni_httpc.http_response
language plpgsql
as $$
begin
    select deribit.internal_jsonrpc_request(url, null::text); --cast to text as a workaround for the anyelement
end
$$;

create or replace function deribit.internal_jsonrpc_request(url text, request anyelement)
returns omni_httpc.http_response
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_error_response deribit.internal_error_response;
    _request_payload jsonb;
begin
    _request_payload := json_build_object(
                        'method', url::text,
                        'jsonrpc', '2.0',
                        'params', jsonb_strip_nulls(to_jsonb(request)),
                        'id', nextval('deribit.internal_jsonrpc_identifier'::regclass)
                        ) as payload;

    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from omni_httpc.http_execute(
        omni_httpc.http_request(
            method := 'POST',
            url := deribit.internal_url_endpoint(url),
            body := _request_payload::text::bytea,
            headers := array[deribit.internal_build_auth_headers()]
    )) as response
    limit 1;

    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.internal_error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

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

create or replace function deribit.unnest_2d_1d(anyarray)
returns setof anyarray
language sql
immutable parallel safe strict as
$$
select array_agg($1[d1][d2])
from generate_subscripts($1, 1) d1,
    generate_subscripts($1, 2) d2
group by d1
order by d1
$$;

comment on function deribit.unnest_2d_1d(anyarray) is 'Unnest a 2d array into a 1d array. Used for Order Books.';

