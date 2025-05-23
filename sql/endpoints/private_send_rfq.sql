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
create type deribit.private_send_rfq_request_side as enum (
    'buy',
    'sell'
);

create type deribit.private_send_rfq_request as (
    "instrument_name" text,
    "amount" double precision,
    "side" deribit.private_send_rfq_request_side
);

comment on column deribit.private_send_rfq_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_send_rfq_request."amount" is 'Amount';
comment on column deribit.private_send_rfq_request."side" is 'Side - buy or sell';

create type deribit.private_send_rfq_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_send_rfq_response."id" is 'The id that was sent in the request';
comment on column deribit.private_send_rfq_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_send_rfq_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_send_rfq(
    "instrument_name" text,
    "amount" double precision default null,
    "side" deribit.private_send_rfq_request_side default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "amount",
            "side"
        )::deribit.private_send_rfq_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/send_rfq'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_send_rfq_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';
