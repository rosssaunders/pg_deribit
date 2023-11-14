insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_positions', null, 0, '0 secs'::interval);

create type deribit.private_get_positions_response_result as (
	average_price float,
	average_price_usd float,
	delta float,
	direction text,
	estimated_liquidation_price float,
	floating_profit_loss float,
	floating_profit_loss_usd float,
	gamma float,
	index_price float,
	initial_margin float,
	instrument_name text,
	interest_value float,
	kind text,
	leverage bigint,
	maintenance_margin float,
	mark_price float,
	open_orders_margin float,
	realized_funding float,
	realized_profit_loss float,
	settlement_price float,
	size float,
	size_currency float,
	theta float,
	total_profit_loss float,
	vega float
);
comment on column deribit.private_get_positions_response_result.average_price is 'Average price of trades that built this position';
comment on column deribit.private_get_positions_response_result.average_price_usd is 'Only for options, average price in USD';
comment on column deribit.private_get_positions_response_result.delta is 'Delta parameter';
comment on column deribit.private_get_positions_response_result.direction is 'Direction: buy, sell or zero';
comment on column deribit.private_get_positions_response_result.estimated_liquidation_price is 'Estimated liquidation price, added only for futures, for non portfolio margining users';
comment on column deribit.private_get_positions_response_result.floating_profit_loss is 'Floating profit or loss';
comment on column deribit.private_get_positions_response_result.floating_profit_loss_usd is 'Only for options, floating profit or loss in USD';
comment on column deribit.private_get_positions_response_result.gamma is 'Only for options, Gamma parameter';
comment on column deribit.private_get_positions_response_result.index_price is 'Current index price';
comment on column deribit.private_get_positions_response_result.initial_margin is 'Initial margin';
comment on column deribit.private_get_positions_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_positions_response_result.interest_value is 'Value used to calculate realized_funding (perpetual only)';
comment on column deribit.private_get_positions_response_result.kind is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.private_get_positions_response_result.leverage is 'Current available leverage for future position';
comment on column deribit.private_get_positions_response_result.maintenance_margin is 'Maintenance margin';
comment on column deribit.private_get_positions_response_result.mark_price is 'Current mark price for position''s instrument';
comment on column deribit.private_get_positions_response_result.open_orders_margin is 'Open orders margin';
comment on column deribit.private_get_positions_response_result.realized_funding is 'Realized Funding in current session included in session realized profit or loss, only for positions of perpetual instruments';
comment on column deribit.private_get_positions_response_result.realized_profit_loss is 'Realized profit or loss';
comment on column deribit.private_get_positions_response_result.settlement_price is 'Optional (not added for spot). Last settlement price for position''s instrument 0 if instrument wasn''t settled yet';
comment on column deribit.private_get_positions_response_result.size is 'Position size for futures size in quote currency (e.g. USD), for options size is in base currency (e.g. BTC)';
comment on column deribit.private_get_positions_response_result.size_currency is 'Only for futures, position size in base currency';
comment on column deribit.private_get_positions_response_result.theta is 'Only for options, Theta parameter';
comment on column deribit.private_get_positions_response_result.total_profit_loss is 'Profit or loss from position';
comment on column deribit.private_get_positions_response_result.vega is 'Only for options, Vega parameter';

create type deribit.private_get_positions_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_positions_response_result[]
);
comment on column deribit.private_get_positions_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_positions_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_positions_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_positions_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo');

create type deribit.private_get_positions_request as (
	currency deribit.private_get_positions_request_currency,
	kind deribit.private_get_positions_request_kind,
	subaccount_id bigint
);
comment on column deribit.private_get_positions_request.currency is '(Required) nan';
comment on column deribit.private_get_positions_request.kind is 'Kind filter on positions';
comment on column deribit.private_get_positions_request.subaccount_id is 'The user id for the subaccount';

create or replace function deribit.private_get_positions(
	currency deribit.private_get_positions_request_currency,
	kind deribit.private_get_positions_request_kind default null,
	subaccount_id bigint default null
)
returns setof deribit.private_get_positions_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_positions_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		kind,
		subaccount_id
    )::deribit.private_get_positions_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_positions', _request);

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.private_get_positions_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.private_get_positions is 'Retrieve user positions. To retrieve subaccount positions, use subaccount_id parameter.';

