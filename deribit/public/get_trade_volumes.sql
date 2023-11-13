insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_trade_volumes', now(), 0, '0 secs'::interval);

create type deribit.public_get_trade_volumes_response_result as (
	calls_volume float,
	calls_volume_30d float,
	calls_volume_7d float,
	currency text,
	futures_volume float,
	futures_volume_30d float,
	futures_volume_7d float,
	puts_volume float,
	puts_volume_30d float,
	puts_volume_7d float,
	spot_volume float,
	spot_volume_30d float,
	spot_volume_7d float
);
comment on column deribit.public_get_trade_volumes_response_result.calls_volume is 'Total 24h trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result.calls_volume_30d is 'Total 30d trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result.calls_volume_7d is 'Total 7d trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.public_get_trade_volumes_response_result.futures_volume is 'Total 24h trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result.futures_volume_30d is 'Total 30d trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result.futures_volume_7d is 'Total 7d trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result.puts_volume is 'Total 24h trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result.puts_volume_30d is 'Total 30d trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result.puts_volume_7d is 'Total 7d trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result.spot_volume is 'Total 24h trade for spot.';
comment on column deribit.public_get_trade_volumes_response_result.spot_volume_30d is 'Total 30d trade for spot.';
comment on column deribit.public_get_trade_volumes_response_result.spot_volume_7d is 'Total 7d trade for spot.';

create type deribit.public_get_trade_volumes_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_trade_volumes_response_result[]
);
comment on column deribit.public_get_trade_volumes_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_trade_volumes_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_trade_volumes_request as (
	extended boolean
);
comment on column deribit.public_get_trade_volumes_request.extended is 'Request for extended statistics. Including also 7 and 30 days volumes (default false)';

create or replace function deribit.public_get_trade_volumes(
	extended boolean default null
)
returns setof deribit.public_get_trade_volumes_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_trade_volumes_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		extended
    )::deribit.public_get_trade_volumes_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_trade_volumes', _request);

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.public_get_trade_volumes_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.public_get_trade_volumes is 'Retrieves aggregated 24h trade volumes for different instrument types and currencies.';

