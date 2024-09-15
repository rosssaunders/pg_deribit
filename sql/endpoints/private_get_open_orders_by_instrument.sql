/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_open_orders_by_instrument_request_type as enum (
    'all',
    'limit',
    'stop_all',
    'stop_limit',
    'stop_market',
    'take_all',
    'take_limit',
    'take_market',
    'trailing_all',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_get_open_orders_by_instrument_request as (
    "instrument_name" text,
    "type" deribit.private_get_open_orders_by_instrument_request_type
);

comment on column deribit.private_get_open_orders_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_open_orders_by_instrument_request."type" is 'Order type, default - all';

create type deribit.private_get_open_orders_by_instrument_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_open_orders_by_instrument_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_open_orders_by_instrument_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_open_orders_by_instrument_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."api" is 'true if created with API';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_open_orders_by_instrument_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_instrument_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_open_orders_by_instrument_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_open_orders_by_instrument_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_open_orders_by_instrument_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_open_orders_by_instrument_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_open_orders_by_instrument_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_instrument_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_open_orders_by_instrument_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_open_orders_by_instrument_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_open_orders_by_instrument_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_open_orders_by_instrument_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_open_orders_by_instrument_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_open_orders_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_open_orders_by_instrument_response_result[]
);

comment on column deribit.private_get_open_orders_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_open_orders_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_open_orders_by_instrument(
    auth deribit.auth
,    "instrument_name" text,
    "type" deribit.private_get_open_orders_by_instrument_request_type default null
)
returns setof deribit.private_get_open_orders_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "type"
        )::deribit.private_get_open_orders_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/get_open_orders_by_instrument'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
        , result as (
select (jsonb_populate_record(
                        null::deribit.private_get_open_orders_by_instrument_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_open_orders_by_instrument is 'Retrieves list of user''s open orders within a given Instrument.';
