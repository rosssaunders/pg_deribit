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
create type deribit.public_get_funding_rate_history_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
);

comment on column deribit.public_get_funding_rate_history_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_history_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_history_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.public_get_funding_rate_history_response_result as (
    "index_price" double precision,
    "interest_1h" double precision,
    "interest_8h" double precision,
    "prev_index_price" double precision,
    "timestamp" bigint
);

comment on column deribit.public_get_funding_rate_history_response_result."index_price" is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result."interest_1h" is '1hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result."interest_8h" is '8hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result."prev_index_price" is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.public_get_funding_rate_history_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_funding_rate_history_response_result[]
);

comment on column deribit.public_get_funding_rate_history_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_history_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_funding_rate_history(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
)
returns setof deribit.public_get_funding_rate_history_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp"
        )::deribit.public_get_funding_rate_history_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_funding_rate_history'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_funding_rate_history_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."index_price"::double precision,
        (b)."interest_1h"::double precision,
        (b)."interest_8h"::double precision,
        (b)."prev_index_price"::double precision,
        (b)."timestamp"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_funding_rate_history is 'Retrieves hourly historical interest rate for requested PERPETUAL instrument.';
