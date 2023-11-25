drop function if exists deribit.public_get_instruments;

create or replace function deribit.public_get_instruments(
	currency deribit.public_get_instruments_request_currency,
	kind deribit.public_get_instruments_request_kind default null,
	expired boolean default null
)
returns setof deribit.public_get_instruments_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			kind,
			expired
        )::deribit.public_get_instruments_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_instruments'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_instruments_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).base_currency::text,
		(b).block_trade_commission::double precision,
		(b).block_trade_min_trade_amount::double precision,
		(b).block_trade_tick_size::double precision,
		(b).contract_size::double precision,
		(b).counter_currency::text,
		(b).creation_timestamp::bigint,
		(b).expiration_timestamp::bigint,
		(b).future_type::text,
		(b).instrument_id::bigint,
		(b).instrument_name::text,
		(b).is_active::boolean,
		(b).kind::text,
		(b).maker_commission::double precision,
		(b).max_leverage::bigint,
		(b).max_liquidation_commission::double precision,
		(b).min_trade_amount::double precision,
		(b).option_type::text,
		(b).price_index::text,
		(b).quote_currency::text,
		(b).rfq::boolean,
		(b).settlement_currency::text,
		(b).settlement_period::text,
		(b).strike::double precision,
		(b).taker_commission::double precision,
		(b).tick_size::double precision,
		(b).tick_size_steps::deribit.public_get_instruments_response_tick_size_step[]
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_instruments is 'Retrieves available trading instruments. This method can be used to see which instruments are available for trading, or which instruments have recently expired.';

