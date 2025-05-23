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
create type deribit.private_withdraw_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_withdraw_request_priority as enum (
    'extreme_high',
    'high',
    'insane',
    'low',
    'mid',
    'very_high',
    'very_low'
);

create type deribit.private_withdraw_request as (
    "currency" deribit.private_withdraw_request_currency,
    "address" text,
    "amount" double precision,
    "priority" deribit.private_withdraw_request_priority
);

comment on column deribit.private_withdraw_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_withdraw_request."address" is '(Required) Address in currency format, it must be in address book';
comment on column deribit.private_withdraw_request."amount" is '(Required) Amount of funds to be withdrawn';
comment on column deribit.private_withdraw_request."priority" is 'Withdrawal priority, optional for BTC, default: high';

create type deribit.private_withdraw_response_result as (
    "address" text,
    "amount" double precision,
    "confirmed_timestamp" bigint,
    "created_timestamp" bigint,
    "currency" text,
    "fee" double precision,
    "id" bigint,
    "priority" double precision,
    "state" text,
    "transaction_id" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_withdraw_response_result."address" is 'Address in proper format for currency';
comment on column deribit.private_withdraw_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_withdraw_response_result."confirmed_timestamp" is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_withdraw_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_withdraw_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_withdraw_response_result."fee" is 'Fee in currency';
comment on column deribit.private_withdraw_response_result."id" is 'Withdrawal id in Deribit system';
comment on column deribit.private_withdraw_response_result."priority" is 'Id of priority level';
comment on column deribit.private_withdraw_response_result."state" is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_withdraw_response_result."transaction_id" is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_withdraw_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_withdraw_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_withdraw_response_result
);

comment on column deribit.private_withdraw_response."id" is 'The id that was sent in the request';
comment on column deribit.private_withdraw_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_withdraw(
    "currency" deribit.private_withdraw_request_currency,
    "address" text,
    "amount" double precision,
    "priority" deribit.private_withdraw_request_priority default null
)
returns deribit.private_withdraw_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "address",
            "amount",
            "priority"
        )::deribit.private_withdraw_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/withdraw'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_withdraw_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_withdraw is 'Creates a new withdrawal request';
