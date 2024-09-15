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
create type deribit.private_get_transfers_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_transfers_request as (
    "currency" deribit.private_get_transfers_request_currency,
    "count" bigint,
    "offset" bigint
);

comment on column deribit.private_get_transfers_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_transfers_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_transfers_request."offset" is 'The offset for pagination, default - 0';

create type deribit.private_get_transfers_response_datum as (
    "amount" double precision,
    "created_timestamp" bigint,
    "currency" text,
    "direction" text,
    "id" bigint,
    "other_side" text,
    "state" text,
    "type" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_get_transfers_response_datum."amount" is 'Amount of funds in given currency';
comment on column deribit.private_get_transfers_response_datum."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_transfers_response_datum."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_transfers_response_datum."direction" is 'Transfer direction';
comment on column deribit.private_get_transfers_response_datum."id" is 'Id of transfer';
comment on column deribit.private_get_transfers_response_datum."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_get_transfers_response_datum."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_get_transfers_response_datum."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_get_transfers_response_datum."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_transfers_response_result as (
    "count" bigint,
    "data" deribit.private_get_transfers_response_datum[]
);

comment on column deribit.private_get_transfers_response_result."count" is 'Total number of results available';

create type deribit.private_get_transfers_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_transfers_response_result
);

comment on column deribit.private_get_transfers_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_transfers_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_transfers(
    auth deribit.auth
,    "currency" deribit.private_get_transfers_request_currency,
    "count" bigint default null,
    "offset" bigint default null
)
returns deribit.private_get_transfers_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "count",
            "offset"
        )::deribit.private_get_transfers_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/get_transfers'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_get_transfers_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_transfers is 'Retrieve the user''s transfers list';
