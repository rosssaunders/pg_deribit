create type deribit.public_get_announcements_response_result as (
	body text,
	confirmation boolean,
	id float,
	important boolean,
	publication_timestamp bigint,
	title text
);
comment on column deribit.public_get_announcements_response_result.body is 'The HTML body of the announcement';
comment on column deribit.public_get_announcements_response_result.confirmation is 'Whether the user confirmation is required for this announcement';
comment on column deribit.public_get_announcements_response_result.id is 'A unique identifier for the announcement';
comment on column deribit.public_get_announcements_response_result.important is 'Whether the announcement is marked as important';
comment on column deribit.public_get_announcements_response_result.publication_timestamp is 'The timestamp (milliseconds since the Unix epoch) of announcement publication';
comment on column deribit.public_get_announcements_response_result.title is 'The title of the announcement';

create type deribit.public_get_announcements_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_announcements_response_result[]
);
comment on column deribit.public_get_announcements_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_announcements_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_announcements_request as (
	start_timestamp bigint,
	count bigint
);
comment on column deribit.public_get_announcements_request.start_timestamp is 'The most recent timestamp to return the results for (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_announcements_request.count is 'Maximum count of returned announcements';

create or replace function deribit.public_get_announcements(
	start_timestamp bigint default null,
	count bigint default null
)
returns deribit.public_get_announcements_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.public_get_announcements_request;
    _error_response deribit.error_response;
begin
    _request := row(
		start_timestamp,
		count
    )::deribit.public_get_announcements_request;

    with request as (
        select json_build_object(
            'method', '/public/get_announcements',
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
                '/public/get_announcements' as end_point
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
        null::deribit.public_get_announcements_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.public_get_announcements is 'Retrieves announcements. Default "start_timestamp" parameter value is current timestamp, "count" parameter value must be between 1 and 50, default is 5.';

