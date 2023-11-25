drop function if exists deribit.private_set_self_trading_config;

create or replace function deribit.private_set_self_trading_config(
	mode deribit.private_set_self_trading_config_request_mode,
	extended_to_subaccounts boolean
)
returns text
language sql
as $$
    
    with request as (
        select row(
			mode,
			extended_to_subaccounts
        )::deribit.private_set_self_trading_config_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/set_self_trading_config'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_set_self_trading_config_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_set_self_trading_config is 'Configure self trading behavior';

