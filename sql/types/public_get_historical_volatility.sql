create type deribit.public_get_historical_volatility_response as (
	id bigint,
	jsonrpc text,
	result UNKNOWN - array of [timestamp, value]
);
comment on column deribit.public_get_historical_volatility_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_historical_volatility_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_historical_volatility_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.public_get_historical_volatility_request as (
	currency deribit.public_get_historical_volatility_request_currency
);
comment on column deribit.public_get_historical_volatility_request.currency is '(Required) The currency symbol';

