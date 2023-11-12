create type deribit.private_get_portfolio_margins_response_result as (

);


create type deribit.private_get_portfolio_margins_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_portfolio_margins_response_result
);
comment on column deribit.private_get_portfolio_margins_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_portfolio_margins_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_portfolio_margins_response.result is 'PM details';

create type deribit.private_get_portfolio_margins_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_portfolio_margins_request as (
	currency deribit.private_get_portfolio_margins_request_currency,
	add_positions boolean,
	simulated_positions jsonb
);
comment on column deribit.private_get_portfolio_margins_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_portfolio_margins_request.add_positions is 'If true, adds simulated positions to current positions, otherwise uses only simulated positions. By default true';
comment on column deribit.private_get_portfolio_margins_request.simulated_positions is 'Object with positions in following form: {InstrumentName1: Position1, InstrumentName2: Position2...}, for example {"BTC-PERPETUAL": -1000.0} (or corresponding URI-encoding for GET). For futures in USD, for options in base currency.';

create or replace function deribit.private_get_portfolio_margins(
	currency deribit.private_get_portfolio_margins_request_currency,
	add_positions boolean default null,
	simulated_positions jsonb default null
)
returns deribit.private_get_portfolio_margins_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_portfolio_margins_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		add_positions,
		simulated_positions
    )::deribit.private_get_portfolio_margins_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/get_portfolio_margins', _request));

    return (jsonb_populate_record(
        null::deribit.private_get_portfolio_margins_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_get_portfolio_margins is 'Calculates portfolio margin info for simulated position or current position of the user. This request has special restricted rate limit (not more than once per a second).';

