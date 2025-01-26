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
create type deribit.private_get_trigger_order_history_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_trigger_order_history_request as (
    "currency" deribit.private_get_trigger_order_history_request_currency,
    "instrument_name" text,
    "count" bigint,
    "continuation" text
);

comment on column deribit.private_get_trigger_order_history_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_trigger_order_history_request."instrument_name" is 'Instrument name';
comment on column deribit.private_get_trigger_order_history_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_trigger_order_history_request."continuation" is 'Continuation token for pagination';

create type deribit.private_get_trigger_order_history_response_entry as (
    "amount" double precision,
    "direction" text,
    "instrument_name" text,
    "is_secondary_oto" boolean,
    "label" text,
    "last_update_timestamp" bigint,
    "oco_ref" text,
    "order_id" text,
    "order_state" text,
    "order_type" text,
    "post_only" boolean,
    "price" double precision,
    "reduce_only" boolean,
    "request" text,
    "source" text,
    "timestamp" bigint,
    "trigger" text,
    "trigger_offset" double precision,
    "trigger_order_id" text,
    "trigger_price" double precision
);

comment on column deribit.private_get_trigger_order_history_response_entry."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_trigger_order_history_response_entry."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_trigger_order_history_response_entry."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_trigger_order_history_response_entry."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_trigger_order_history_response_entry."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_trigger_order_history_response_entry."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_trigger_order_history_response_entry."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_trigger_order_history_response_entry."order_id" is 'Unique order identifier';
comment on column deribit.private_get_trigger_order_history_response_entry."order_state" is 'Order state: "triggered", "cancelled", or "rejected" with rejection reason (e.g. "rejected:reduce_direction").';
comment on column deribit.private_get_trigger_order_history_response_entry."order_type" is 'Requested order type: "limit or "market"';
comment on column deribit.private_get_trigger_order_history_response_entry."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_trigger_order_history_response_entry."price" is 'Price in base currency';
comment on column deribit.private_get_trigger_order_history_response_entry."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_trigger_order_history_response_entry."request" is 'Type of last request performed on the trigger order by user or system. "cancel" - when order was cancelled, "trigger:order" - when trigger order spawned market or limit order after being triggered';
comment on column deribit.private_get_trigger_order_history_response_entry."source" is 'Source of the order that is linked to the trigger order.';
comment on column deribit.private_get_trigger_order_history_response_entry."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger_order_id" is 'Id of the user order used for the trigger-order reference before triggering';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger_price" is 'Trigger price (Only for future trigger orders)';

create type deribit.private_get_trigger_order_history_response_result as (
    "continuation" text,
    "entries" deribit.private_get_trigger_order_history_response_entry[]
);

comment on column deribit.private_get_trigger_order_history_response_result."continuation" is 'Continuation token for pagination.';

create type deribit.private_get_trigger_order_history_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_trigger_order_history_response_result
);

comment on column deribit.private_get_trigger_order_history_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_trigger_order_history_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_trigger_order_history(
    "currency" deribit.private_get_trigger_order_history_request_currency,
    "instrument_name" text default null,
    "count" bigint default null,
    "continuation" text default null
)
returns deribit.private_get_trigger_order_history_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "instrument_name",
            "count",
            "continuation"
        )::deribit.private_get_trigger_order_history_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_trigger_order_history'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_trigger_order_history_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_trigger_order_history is 'Retrieves detailed log of the user''s trigger orders.';
