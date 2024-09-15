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
create type deribit.private_reset_mmp_request_index_name as enum (
    'ada_usdc',
    'ada_usdt',
    'algo_usdc',
    'algo_usdt',
    'avax_usdc',
    'avax_usdt',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usdc',
    'doge_usdt',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usdc',
    'link_usdt',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usdc',
    'matic_usdt',
    'near_usdc',
    'near_usdt',
    'shib_usdc',
    'shib_usdt',
    'sol_usdc',
    'sol_usdt',
    'trx_usdc',
    'trx_usdt',
    'uni_usdc',
    'uni_usdt',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.private_reset_mmp_request as (
    "index_name" deribit.private_reset_mmp_request_index_name,
    "mmp_group" text
);

comment on column deribit.private_reset_mmp_request."index_name" is '(Required) Index identifier of derivative instrument on the platform';
comment on column deribit.private_reset_mmp_request."mmp_group" is 'Specifies the MMP group for which limits are being reset. If this parameter is omitted, the endpoint resets the traditional (no group) MMP limits';

create type deribit.private_reset_mmp_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_reset_mmp_response."id" is 'The id that was sent in the request';
comment on column deribit.private_reset_mmp_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_reset_mmp_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_reset_mmp(
    auth deribit.auth
,    "index_name" deribit.private_reset_mmp_request_index_name,
    "mmp_group" text default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "index_name",
            "mmp_group"
        )::deribit.private_reset_mmp_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/reset_mmp'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (jsonb_populate_record(
        null::deribit.private_reset_mmp_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_reset_mmp is 'Reset MMP';
