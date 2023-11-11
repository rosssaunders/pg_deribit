create type deribit.private_get_open_orders_by_currency_response_result as (
	reject_post_only boolean,
	label text,
	order_state text,
	usd float,
	implv float,
	trigger_reference_price float,
	original_order_type text,
	block_trade boolean,
	trigger_price float,
	api boolean,
	mmp boolean,
	trigger_order_id text,
	cancel_reason text,
	risk_reducing boolean,
	filled_amount float,
	instrument_name text,
	max_show float,
	app_name text,
	mmp_cancelled boolean,
	direction text,
	last_update_timestamp bigint,
	trigger_offset float,
	price text,
	is_liquidation boolean,
	reduce_only boolean,
	amount float,
	post_only boolean,
	mobile boolean,
	triggered boolean,
	order_id text,
	replaced boolean,
	order_type text,
	time_in_force text,
	auto_replaced boolean,
	trigger text,
	web boolean,
	creation_timestamp bigint,
	average_price float,
	advanced text
);
comment on column deribit.private_get_open_orders_by_currency_response_result.reject_post_only is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_open_orders_by_currency_response_result.label is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_open_orders_by_currency_response_result.order_state is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_open_orders_by_currency_response_result.usd is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_open_orders_by_currency_response_result.implv is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_open_orders_by_currency_response_result.trigger_reference_price is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_currency_response_result.original_order_type is 'Original order type. Optional field';
comment on column deribit.private_get_open_orders_by_currency_response_result.block_trade is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_open_orders_by_currency_response_result.trigger_price is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_open_orders_by_currency_response_result.api is 'true if created with API';
comment on column deribit.private_get_open_orders_by_currency_response_result.mmp is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result.trigger_order_id is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_open_orders_by_currency_response_result.cancel_reason is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting)';
comment on column deribit.private_get_open_orders_by_currency_response_result.risk_reducing is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result.filled_amount is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_currency_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_open_orders_by_currency_response_result.max_show is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_open_orders_by_currency_response_result.app_name is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_open_orders_by_currency_response_result.mmp_cancelled is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_open_orders_by_currency_response_result.direction is 'Direction: buy, or sell';
comment on column deribit.private_get_open_orders_by_currency_response_result.last_update_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_currency_response_result.trigger_offset is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_currency_response_result.price is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_open_orders_by_currency_response_result.is_liquidation is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_open_orders_by_currency_response_result.reduce_only is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_open_orders_by_currency_response_result.amount is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_currency_response_result.post_only is 'true for post-only orders only';
comment on column deribit.private_get_open_orders_by_currency_response_result.mobile is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_open_orders_by_currency_response_result.triggered is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_open_orders_by_currency_response_result.order_id is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_currency_response_result.replaced is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result.order_type is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_open_orders_by_currency_response_result.time_in_force is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_open_orders_by_currency_response_result.auto_replaced is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result.trigger is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_open_orders_by_currency_response_result.web is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_open_orders_by_currency_response_result.creation_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_currency_response_result.average_price is 'Average fill price of the order';
comment on column deribit.private_get_open_orders_by_currency_response_result.advanced is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_open_orders_by_currency_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_open_orders_by_currency_response_result[]
);
comment on column deribit.private_get_open_orders_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_open_orders_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_open_orders_by_currency_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_open_orders_by_currency_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo');

create type deribit.private_get_open_orders_by_currency_request_type as enum ('all', 'limit', 'trigger_all', 'stop_all', 'stop_limit', 'stop_market', 'take_all', 'take_limit', 'take_market', 'trailing_all', 'trailing_stop');

create type deribit.private_get_open_orders_by_currency_request as (
	currency deribit.private_get_open_orders_by_currency_request_currency,
	kind deribit.private_get_open_orders_by_currency_request_kind,
	type deribit.private_get_open_orders_by_currency_request_type
);
comment on column deribit.private_get_open_orders_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_open_orders_by_currency_request.kind is 'Instrument kind, if not provided instruments of all kinds are considered';
comment on column deribit.private_get_open_orders_by_currency_request.type is 'Order type, default - all';

create or replace function deribit.private_get_open_orders_by_currency(
	currency deribit.private_get_open_orders_by_currency_request_currency,
	kind deribit.private_get_open_orders_by_currency_request_kind default null,
	type deribit.private_get_open_orders_by_currency_request_type default null
)
returns deribit.private_get_open_orders_by_currency_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_open_orders_by_currency_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		kind,
		type
    )::deribit.private_get_open_orders_by_currency_request;

    with request as (
        select json_build_object(
            'method', '/private/get_open_orders_by_currency',
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
                '/private/get_open_orders_by_currency' as end_point
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
        null::deribit.private_get_open_orders_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_open_orders_by_currency is 'Retrieves list of user''s open orders.';

