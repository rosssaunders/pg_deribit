drop type if exists deribit.public_get_historical_volatility_response_result cascade;
create type deribit.public_get_historical_volatility_response_result as (
	timestamp bigint,
	value double precision
);


drop type if exists deribit.public_get_historical_volatility_response cascade;
create type deribit.public_get_historical_volatility_response as (
	id bigint,
	jsonrpc text,
	result double precision[][]
);
comment on column deribit.public_get_historical_volatility_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_historical_volatility_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_historical_volatility_request_currency cascade;
create type deribit.public_get_historical_volatility_request_currency as enum ('ETH', 'BTC', 'USDC');

drop type if exists deribit.public_get_historical_volatility_request cascade;
create type deribit.public_get_historical_volatility_request as (
	currency deribit.public_get_historical_volatility_request_currency
);
comment on column deribit.public_get_historical_volatility_request.currency is '(Required) The currency symbol';

