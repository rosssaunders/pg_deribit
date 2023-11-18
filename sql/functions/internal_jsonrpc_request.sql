-- create or replace function deribit.internal_jsonrpc_request(url text)
-- returns omni_httpc.http_response
-- language plpgsql
-- as $$
-- begin
--     select deribit.internal_jsonrpc_request(url, null::text); --cast to text as a workaround for the anyelement
-- end
-- $$;

create or replace function deribit.internal_jsonrpc_request(url text, request anyelement)
returns omni_httpc.http_response
language plpgsql
as $$
declare
    _http_request omni_httpc.http_request;
    _http_response omni_httpc.http_response;
	_error_response deribit.internal_error_response;
    _request_payload jsonb;
    _rate_limit_delay float;
    _id bigint;
begin
    _id := nextval('deribit.internal_jsonrpc_identifier'::regclass);

    _request_payload := json_build_object(
                        'method', url::text,
                        'jsonrpc', '2.0',
                        'params', jsonb_strip_nulls(to_jsonb(request)),
                        'id', _id
                        ) as payload;

    _rate_limit_delay := 0.25; --(select deribit.internal_rate_limit(url));

    update deribit.internal_endpoint_rate_limit
        set last_call = current_timestamp,
            calls = calls + 1,
            time_waiting = time_waiting + (select justify_interval(cast(_rate_limit_delay::text || ' seconds' AS interval)))
        where key = url;
    perform pg_sleep(_rate_limit_delay);

    _http_request := omni_httpc.http_request(
            method := 'POST',
            url := deribit.internal_url_endpoint(url),
            body := _request_payload::text::bytea,
            headers := array[deribit.internal_build_auth_headers()]
    );

    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from omni_httpc.http_execute(_http_request) as response
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

    insert into deribit.internal_archive(id, url, request, response)
    values (_id, url, _request_payload, to_json(_http_response));

    return _http_response;

    end;
$$;