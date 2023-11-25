drop function if exists deribit.public_get_trade_volumes;

create or replace function deribit.public_get_trade_volumes(
	extended boolean default null
)
returns setof deribit.public_get_trade_volumes_response_result
language sql
as $$
    
    with request as (
        select row(
			extended
        )::deribit.public_get_trade_volumes_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_trade_volumes'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_trade_volumes_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).calls_volume::double precision,
		(b).calls_volume_30d::double precision,
		(b).calls_volume_7d::double precision,
		(b).currency::text,
		(b).futures_volume::double precision,
		(b).futures_volume_30d::double precision,
		(b).futures_volume_7d::double precision,
		(b).puts_volume::double precision,
		(b).puts_volume_30d::double precision,
		(b).puts_volume_7d::double precision,
		(b).spot_volume::double precision,
		(b).spot_volume_30d::double precision,
		(b).spot_volume_7d::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_trade_volumes is 'Retrieves aggregated 24h trade volumes for different instrument types and currencies.';

