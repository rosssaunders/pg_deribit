create type deribit.private_submit_transfer_to_subaccount_response_result as (
	amount float,
	created_timestamp bigint,
	currency text,
	direction text,
	id bigint,
	other_side text,
	state text,
	type text,
	updated_timestamp bigint
);
comment on column deribit.private_submit_transfer_to_subaccount_response_result.amount is 'Amount of funds in given currency';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.direction is 'Transfer direction';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.id is 'Id of transfer';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.other_side is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.state is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.type is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_submit_transfer_to_subaccount_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_submit_transfer_to_subaccount_response_result
);
comment on column deribit.private_submit_transfer_to_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_submit_transfer_to_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_submit_transfer_to_subaccount_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_submit_transfer_to_subaccount_request as (
	currency deribit.private_submit_transfer_to_subaccount_request_currency,
	amount float,
	destination bigint
);
comment on column deribit.private_submit_transfer_to_subaccount_request.currency is '(Required) The currency symbol';
comment on column deribit.private_submit_transfer_to_subaccount_request.amount is '(Required) Amount of funds to be transferred';
comment on column deribit.private_submit_transfer_to_subaccount_request.destination is '(Required) Id of destination subaccount. Can be found in My Account >> Subaccounts tab';

create or replace function deribit.private_submit_transfer_to_subaccount(
	currency deribit.private_submit_transfer_to_subaccount_request_currency,
	amount float,
	destination bigint
)
returns deribit.private_submit_transfer_to_subaccount_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_submit_transfer_to_subaccount_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		amount,
		destination
    )::deribit.private_submit_transfer_to_subaccount_request;

    with request as (
        select json_build_object(
            'method', '/private/submit_transfer_to_subaccount',
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
                '/private/submit_transfer_to_subaccount' as end_point
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
        null::deribit.private_submit_transfer_to_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_submit_transfer_to_subaccount is 'Transfer funds to subaccount.';

