drop function if exists deribit.private_get_portfolio_margins;

create or replace function deribit.private_get_portfolio_margins(
	currency deribit.private_get_portfolio_margins_request_currency,
	add_positions boolean default null,
	simulated_positions jsonb default null
)
returns deribit.private_get_portfolio_margins_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			add_positions,
			simulated_positions
        )::deribit.private_get_portfolio_margins_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_portfolio_margins'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_portfolio_margins_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_portfolio_margins is 'Calculates portfolio margin info for simulated position or current position of the user. This request has special restricted rate limit (not more than once per a second).';

