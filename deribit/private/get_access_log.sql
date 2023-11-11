create type deribit.private_get_access_log_response_result as (
	city text,
	country text,
	data UNKNOWN - object or string,
	id bigint,
	ip text,
	log text,
	timestamp bigint
);
comment on column deribit.private_get_access_log_response_result.city is 'City where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result.country is 'Country where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result.data is 'Optional, additional information about action, type depends on log value';
comment on column deribit.private_get_access_log_response_result.id is 'Unique identifier';
comment on column deribit.private_get_access_log_response_result.ip is 'IP address of source that generated action';
comment on column deribit.private_get_access_log_response_result.log is 'Action description, values: changed_email - email was changed; changed_password - password was changed; disabled_tfa - TFA was disabled; enabled_tfa - TFA was enabled, success - successful login; failure - login failure; enabled_subaccount_login - login was enabled for subaccount (in data - subaccount uid); disabled_subaccount_login - login was disabled for subbaccount (in data - subbacount uid);new_api_key - API key was created (in data key client id); removed_api_key - API key was removed (in data key client id); changed_scope - scope of API key was changed (in data key client id); changed_whitelist - whitelist of API key was edited (in data key client id); disabled_api_key - API key was disabled (in data key client id); enabled_api_key - API key was enabled (in data key client id); reset_api_key - API key was reset (in data key client id)';
comment on column deribit.private_get_access_log_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_access_log_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_access_log_response_result[]
);
comment on column deribit.private_get_access_log_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_access_log_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_access_log_request as (
	"offset" bigint,
	count bigint
);
comment on column deribit.private_get_access_log_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.private_get_access_log_request.count is 'Number of requested items, default - 10';

create or replace function deribit.private_get_access_log(
	"offset" bigint default null,
	count bigint default null
)
returns deribit.private_get_access_log_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_access_log_request;
    _error_response deribit.error_response;
begin
    _request := row(
		"offset",
		count
    )::deribit.private_get_access_log_request;

    with request as (
        select json_build_object(
            'method', '/private/get_access_log',
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
                '/private/get_access_log' as end_point
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
        null::deribit.private_get_access_log_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_access_log is 'Lists access logs for the user';

