create type deribit.private_get_transaction_log_response_info as (
	instrument_name text,
	interest_pl float,
	mark_price float,
	order_id text,
	position float,
	price float,
	price_currency text,
	profit_as_cashflow boolean,
	session_rpl float,
	session_upl float,
	side text,
	timestamp bigint,
	total_interest_pl float,
	trade_id text,
	type text,
	user_id bigint,
	user_role text,
	user_seq bigint,
	username text
);
comment on column deribit.private_get_transaction_log_response_info.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_transaction_log_response_info.interest_pl is 'Actual funding rate of trades and settlements on perpetual instruments';
comment on column deribit.private_get_transaction_log_response_info.mark_price is 'Market price during the trade';
comment on column deribit.private_get_transaction_log_response_info.order_id is 'Unique order identifier';
comment on column deribit.private_get_transaction_log_response_info.position is 'Updated position size after the transaction';
comment on column deribit.private_get_transaction_log_response_info.price is 'Settlement/delivery price or the price level of the traded contracts';
comment on column deribit.private_get_transaction_log_response_info.price_currency is 'Currency symbol associated with the price field value';
comment on column deribit.private_get_transaction_log_response_info.profit_as_cashflow is 'Indicator informing whether the cashflow is waiting for settlement or not';
comment on column deribit.private_get_transaction_log_response_info.session_rpl is 'Session realized profit and loss';
comment on column deribit.private_get_transaction_log_response_info.session_upl is 'Session unrealized profit and loss';
comment on column deribit.private_get_transaction_log_response_info.side is 'One of: short or long in case of settlements, close sell or close buy in case of deliveries, open sell, open buy, close sell, close buy in case of trades';
comment on column deribit.private_get_transaction_log_response_info.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_transaction_log_response_info.total_interest_pl is 'Total session funding rate';
comment on column deribit.private_get_transaction_log_response_info.trade_id is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_transaction_log_response_info.type is 'Transaction category/type. The most common are: trade, deposit, withdrawal, settlement, delivery, transfer, swap, correction. New types can be added any time in the future';
comment on column deribit.private_get_transaction_log_response_info.user_id is 'Unique user identifier';
comment on column deribit.private_get_transaction_log_response_info.user_role is 'Trade role of the user: maker or taker';
comment on column deribit.private_get_transaction_log_response_info.user_seq is 'Sequential identifier of user transaction';
comment on column deribit.private_get_transaction_log_response_info.username is 'System name or user defined subaccount alias';

create type deribit.private_get_transaction_log_response_log as (
	amount float,
	balance float,
	cashflow float,
	change float,
	commission float,
	currency text,
	equity float,
	id bigint,
	info deribit.private_get_transaction_log_response_info
);
comment on column deribit.private_get_transaction_log_response_log.amount is 'It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is underlying base currency coin. For options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_get_transaction_log_response_log.balance is 'Cash balance after the transaction';
comment on column deribit.private_get_transaction_log_response_log.cashflow is 'For futures and perpetual contracts: Realized session PNL (since last settlement). For options: the amount paid or received for the options traded.';
comment on column deribit.private_get_transaction_log_response_log.change is 'Change in cash balance. For trades: fees and options premium paid/received. For settlement: Futures session PNL and perpetual session funding.';
comment on column deribit.private_get_transaction_log_response_log.commission is 'Commission paid so far (in base currency)';
comment on column deribit.private_get_transaction_log_response_log.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_transaction_log_response_log.equity is 'Updated equity value after the transaction';
comment on column deribit.private_get_transaction_log_response_log.id is 'Unique identifier';
comment on column deribit.private_get_transaction_log_response_log.info is 'Additional information regarding transaction. Strongly dependent on the log entry type';

create type deribit.private_get_transaction_log_response_result as (
	continuation bigint
);
comment on column deribit.private_get_transaction_log_response_result.continuation is 'Continuation token for pagination. NULL when no continuation.';

create type deribit.private_get_transaction_log_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_transaction_log_response_result,
	logs deribit.private_get_transaction_log_response_log[]
);
comment on column deribit.private_get_transaction_log_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_transaction_log_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_transaction_log_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_transaction_log_request as (
	currency deribit.private_get_transaction_log_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	query text,
	count bigint,
	continuation bigint
);
comment on column deribit.private_get_transaction_log_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_transaction_log_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_transaction_log_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_transaction_log_request.query is 'The following keywords can be used to filter the results: trade, maker, taker, open, close, liquidation, buy, sell, withdrawal, delivery, settlement, deposit, transfer, option, future, correction, block_trade, swap. Plus withdrawal or transfer addresses';
comment on column deribit.private_get_transaction_log_request.count is 'Number of requested items, default - 100';
comment on column deribit.private_get_transaction_log_request.continuation is 'Continuation token for pagination';

create or replace function deribit.private_get_transaction_log(
	currency deribit.private_get_transaction_log_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	query text default null,
	count bigint default null,
	continuation bigint default null
)
returns deribit.private_get_transaction_log_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_transaction_log_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		start_timestamp,
		end_timestamp,
		query,
		count,
		continuation
    )::deribit.private_get_transaction_log_request;

    with request as (
        select json_build_object(
            'method', '/private/get_transaction_log',
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
                '/private/get_transaction_log' as end_point
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
        null::deribit.private_get_transaction_log_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_transaction_log is 'Retrieve the latest user trades that have occurred for a specific instrument and within given time range.';

