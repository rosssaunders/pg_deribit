drop type if exists deribit.public_get_portfolio_margins_response_result cascade;
create type deribit.public_get_portfolio_margins_response_result as (

);


drop type if exists deribit.public_get_portfolio_margins_response cascade;
create type deribit.public_get_portfolio_margins_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_portfolio_margins_response_result
);
comment on column deribit.public_get_portfolio_margins_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_portfolio_margins_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_portfolio_margins_response.result is 'PM details';

drop type if exists deribit.public_get_portfolio_margins_request_currency cascade;
create type deribit.public_get_portfolio_margins_request_currency as enum ('ETH', 'USDC', 'BTC');

drop type if exists deribit.public_get_portfolio_margins_request cascade;
create type deribit.public_get_portfolio_margins_request as (
	currency deribit.public_get_portfolio_margins_request_currency,
	simulated_positions jsonb
);
comment on column deribit.public_get_portfolio_margins_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_portfolio_margins_request.simulated_positions is 'Object with positions in following form: {InstrumentName1: Position1, InstrumentName2: Position2...}, for example {"BTC-PERPETUAL": -1000.0} (or corresponding URI-encoding for GET). For futures in USD, for options in base currency.';

