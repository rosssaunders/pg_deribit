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
create type deribit.private_pme_simulate_request_currency as enum (
    'BTC',
    'CROSS',
    'ETH',
    'EURR',
    'MATIC',
    'SOL',
    'USDC',
    'USDT',
    'XRP'
);

create type deribit.private_pme_simulate_request as (
    "currency" deribit.private_pme_simulate_request_currency
);

comment on column deribit.private_pme_simulate_request."currency" is '(Required) The currency for which the Extended Risk Matrix will be calculated. Use CROSS for Cross Collateral simulation.';

create type deribit.private_pme_simulate_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" jsonb
);

comment on column deribit.private_pme_simulate_response."id" is 'The id that was sent in the request';
comment on column deribit.private_pme_simulate_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_pme_simulate_response."result" is 'PM details';

create function deribit.private_pme_simulate(
    "currency" deribit.private_pme_simulate_request_currency
)
returns jsonb
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.private_pme_simulate_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/pme/simulate'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_pme_simulate_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_pme_simulate is 'Calculates the Extended Risk Matrix and margin information for the selected currency or against the entire Cross-Collateral portfolio.';
