create type deribit.private_cancel_withdrawal_response_result as (
	address text,
	amount float,
	confirmed_timestamp bigint,
	created_timestamp bigint,
	currency text,
	fee float,
	id bigint,
	priority float,
	state text,
	transaction_id text,
	updated_timestamp bigint
);
comment on column deribit.private_cancel_withdrawal_response_result.address is 'Address in proper format for currency';
comment on column deribit.private_cancel_withdrawal_response_result.amount is 'Amount of funds in given currency';
comment on column deribit.private_cancel_withdrawal_response_result.confirmed_timestamp is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_cancel_withdrawal_response_result.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_withdrawal_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_cancel_withdrawal_response_result.fee is 'Fee in currency';
comment on column deribit.private_cancel_withdrawal_response_result.id is 'Withdrawal id in Deribit system';
comment on column deribit.private_cancel_withdrawal_response_result.priority is 'Id of priority level';
comment on column deribit.private_cancel_withdrawal_response_result.state is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_cancel_withdrawal_response_result.transaction_id is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_cancel_withdrawal_response_result.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_cancel_withdrawal_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_cancel_withdrawal_response_result
);
comment on column deribit.private_cancel_withdrawal_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_withdrawal_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_cancel_withdrawal_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_cancel_withdrawal_request as (
	currency deribit.private_cancel_withdrawal_request_currency,
	id float
);
comment on column deribit.private_cancel_withdrawal_request.currency is '(Required) The currency symbol';
comment on column deribit.private_cancel_withdrawal_request.id is '(Required) The withdrawal id';

create or replace function deribit.private_cancel_withdrawal(
	currency deribit.private_cancel_withdrawal_request_currency,
	id float
)
returns deribit.private_cancel_withdrawal_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_cancel_withdrawal_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		id
    )::deribit.private_cancel_withdrawal_request;

    with request as (
        select json_build_object(
            'method', '/private/cancel_withdrawal',
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
                '/private/cancel_withdrawal' as end_point
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
        null::deribit.private_cancel_withdrawal_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_cancel_withdrawal is 'Cancels withdrawal request';

