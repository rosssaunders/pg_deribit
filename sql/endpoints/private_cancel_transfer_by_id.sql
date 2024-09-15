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
create type deribit.private_cancel_transfer_by_id_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_cancel_transfer_by_id_request as (
    "currency" deribit.private_cancel_transfer_by_id_request_currency,
    "id" bigint
);

comment on column deribit.private_cancel_transfer_by_id_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_cancel_transfer_by_id_request."id" is '(Required) Id of transfer';

create type deribit.private_cancel_transfer_by_id_response_result as (
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

comment on column deribit.private_cancel_transfer_by_id_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_cancel_transfer_by_id_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_transfer_by_id_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_cancel_transfer_by_id_response_result."direction" is 'Transfer direction';
comment on column deribit.private_cancel_transfer_by_id_response_result."id" is 'Id of transfer';
comment on column deribit.private_cancel_transfer_by_id_response_result."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_cancel_transfer_by_id_response_result."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_cancel_transfer_by_id_response_result."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_cancel_transfer_by_id_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_cancel_transfer_by_id_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_cancel_transfer_by_id_response_result
);

comment on column deribit.private_cancel_transfer_by_id_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_transfer_by_id_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_cancel_transfer_by_id(
    auth deribit.auth
,    "currency" deribit.private_cancel_transfer_by_id_request_currency,
    "id" bigint
)
returns deribit.private_cancel_transfer_by_id_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "id"
        )::deribit.private_cancel_transfer_by_id_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/cancel_transfer_by_id'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_cancel_transfer_by_id_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel_transfer_by_id is 'Cancel transfer';
