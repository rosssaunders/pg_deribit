create type deribit.private_get_subaccounts_response_eth as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	proof_id text,
	proof_id_signature text,
	receive_notifications boolean,
	security_keys_assignments text[],
	security_keys_enabled boolean,
	system_name text,
	type text,
	username text
);
comment on column deribit.private_get_subaccounts_response_eth.proof_id is 'hashed identifier used in the Proof Of Liability for the subaccount. This identifier allows you to find your entries in the Deribit Proof-Of-Reserves files. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_eth.proof_id_signature is 'signature used as a base string for proof_id hash. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_eth.receive_notifications is 'When true - receive all notification emails on the main email';
comment on column deribit.private_get_subaccounts_response_eth.security_keys_assignments is 'Names of assignments with Security Keys assigned';
comment on column deribit.private_get_subaccounts_response_eth.security_keys_enabled is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_get_subaccounts_response_eth.system_name is 'System generated user nickname';

create type deribit.private_get_subaccounts_response_btc as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	eth deribit.private_get_subaccounts_response_eth
);


create type deribit.private_get_subaccounts_response_portfolio as (
	btc deribit.private_get_subaccounts_response_btc
);


create type deribit.private_get_subaccounts_response_result as (
	email text,
	id bigint,
	is_password boolean,
	login_enabled boolean,
	not_confirmed_email text,
	portfolio deribit.private_get_subaccounts_response_portfolio
);
comment on column deribit.private_get_subaccounts_response_result.email is 'User email';
comment on column deribit.private_get_subaccounts_response_result.id is 'Account/Subaccount identifier';
comment on column deribit.private_get_subaccounts_response_result.is_password is 'true when password for the subaccount has been configured';
comment on column deribit.private_get_subaccounts_response_result.login_enabled is 'Informs whether login to the subaccount is enabled';
comment on column deribit.private_get_subaccounts_response_result.not_confirmed_email is 'New email address that has not yet been confirmed. This field is only included if with_portfolio == true.';

create type deribit.private_get_subaccounts_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_subaccounts_response_result[]
);
comment on column deribit.private_get_subaccounts_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_subaccounts_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_subaccounts_request as (
	with_portfolio boolean
);
comment on column deribit.private_get_subaccounts_request.with_portfolio is 'nan';

create or replace function deribit.private_get_subaccounts(
	with_portfolio boolean default null
)
returns deribit.private_get_subaccounts_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_subaccounts_request;
    _error_response deribit.error_response;
begin
    _request := row(
		with_portfolio
    )::deribit.private_get_subaccounts_request;

    with request as (
        select json_build_object(
            'method', '/private/get_subaccounts',
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
                '/private/get_subaccounts' as end_point
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
        null::deribit.private_get_subaccounts_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_subaccounts is 'Get information about subaccounts';

