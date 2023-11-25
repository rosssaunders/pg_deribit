drop function if exists deribit.private_get_positions;

create or replace function deribit.private_get_positions(
	currency deribit.private_get_positions_request_currency,
	kind deribit.private_get_positions_request_kind default null,
	subaccount_id bigint default null
)
returns setof deribit.private_get_positions_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			kind,
			subaccount_id
        )::deribit.private_get_positions_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_positions'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_positions_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).average_price::double precision,
		(b).average_price_usd::double precision,
		(b).delta::double precision,
		(b).direction::text,
		(b).estimated_liquidation_price::double precision,
		(b).floating_profit_loss::double precision,
		(b).floating_profit_loss_usd::double precision,
		(b).gamma::double precision,
		(b).index_price::double precision,
		(b).initial_margin::double precision,
		(b).instrument_name::text,
		(b).interest_value::double precision,
		(b).kind::text,
		(b).leverage::bigint,
		(b).maintenance_margin::double precision,
		(b).mark_price::double precision,
		(b).open_orders_margin::double precision,
		(b).realized_funding::double precision,
		(b).realized_profit_loss::double precision,
		(b).settlement_price::double precision,
		(b).size::double precision,
		(b).size_currency::double precision,
		(b).theta::double precision,
		(b).total_profit_loss::double precision,
		(b).vega::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_positions is 'Retrieve user positions. To retrieve subaccount positions, use subaccount_id parameter.';

