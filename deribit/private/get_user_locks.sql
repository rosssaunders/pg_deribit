create type deribit.private_get_user_locks_response_result as (
	currency text,
	enabled boolean,
	message UNKNOWN - text
);
comment on column deribit.private_get_user_locks_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_locks_response_result.enabled is 'Value is set to ''true'' when user account is locked in currency';
comment on column deribit.private_get_user_locks_response_result.message is 'Optional information for user why his account is locked';

create type deribit.private_get_user_locks_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_user_locks_response_result[]
);
comment on column deribit.private_get_user_locks_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_user_locks_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_user_locks()
returns deribit.private_get_user_locks_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
    _error_response deribit.error_response;
begin
    
    with request as (
        select json_build_object(
            'method', '/private/get_user_locks',
            'params', null,
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
                '/private/get_user_locks' as end_point
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
        null::deribit.private_get_user_locks_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_user_locks is 'Retrieves information about locks on user account';

