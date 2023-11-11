create type deribit.private_create_subaccount_response_eth as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	receive_notifications boolean,
	security_keys_enabled boolean,
	system_name text,
	type text,
	username text
);
comment on column deribit.private_create_subaccount_response_eth.receive_notifications is 'When true - receive all notification emails on the main email';
comment on column deribit.private_create_subaccount_response_eth.security_keys_enabled is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_create_subaccount_response_eth.system_name is 'System generated user nickname';
comment on column deribit.private_create_subaccount_response_eth.type is 'Account type';
comment on column deribit.private_create_subaccount_response_eth.username is 'Account name (given by user)';

create type deribit.private_create_subaccount_response_btc as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	eth deribit.private_create_subaccount_response_eth
);


create type deribit.private_create_subaccount_response_portfolio as (
	btc deribit.private_create_subaccount_response_btc
);


create type deribit.private_create_subaccount_response_result as (
	email text,
	id bigint,
	is_password boolean,
	login_enabled boolean,
	portfolio deribit.private_create_subaccount_response_portfolio
);
comment on column deribit.private_create_subaccount_response_result.email is 'User email';
comment on column deribit.private_create_subaccount_response_result.id is 'Subaccount identifier';
comment on column deribit.private_create_subaccount_response_result.is_password is 'true when password for the subaccount has been configured';
comment on column deribit.private_create_subaccount_response_result.login_enabled is 'Informs whether login to the subaccount is enabled';

create type deribit.private_create_subaccount_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_create_subaccount_response_result
);
comment on column deribit.private_create_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_create_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_create_subaccount()
returns deribit.private_create_subaccount_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
    _error_response deribit.error_response;
begin
    
    with request as (
        select json_build_object(
            'method', '/private/create_subaccount',
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
                '/private/create_subaccount' as end_point
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
        null::deribit.private_create_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_create_subaccount is 'Create a new subaccount';

