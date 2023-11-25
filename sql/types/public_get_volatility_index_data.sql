drop type if exists deribit.public_get_volatility_index_data_response_datum cascade;
create type deribit.public_get_volatility_index_data_response_datum as (

);


drop type if exists deribit.public_get_volatility_index_data_response_result cascade;
create type deribit.public_get_volatility_index_data_response_result as (
	continuation bigint,
	data deribit.public_get_volatility_index_data_response_datum[]
);
comment on column deribit.public_get_volatility_index_data_response_result.continuation is 'Continuation - to be used as the end_timestamp parameter on the next request. NULL when no continuation.';
comment on column deribit.public_get_volatility_index_data_response_result.data is 'Candles as an array of arrays with 5 values each. The inner values correspond to the timestamp in ms, open, high, low, and close values of the volatility index correspondingly.';

drop type if exists deribit.public_get_volatility_index_data_response cascade;
create type deribit.public_get_volatility_index_data_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_volatility_index_data_response_result
);
comment on column deribit.public_get_volatility_index_data_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_volatility_index_data_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_volatility_index_data_response.result is 'Volatility index candles.';

drop type if exists deribit.public_get_volatility_index_data_request_currency cascade;
create type deribit.public_get_volatility_index_data_request_currency as enum ('BTC', 'USDC', 'ETH');

drop type if exists deribit.public_get_volatility_index_data_request_resolution cascade;
create type deribit.public_get_volatility_index_data_request_resolution as enum ('3600', '43200', '1', '60', '1D');

drop type if exists deribit.public_get_volatility_index_data_request cascade;
create type deribit.public_get_volatility_index_data_request as (
	currency deribit.public_get_volatility_index_data_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_volatility_index_data_request_resolution
);
comment on column deribit.public_get_volatility_index_data_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_volatility_index_data_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_volatility_index_data_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_volatility_index_data_request.resolution is '(Required) Time resolution given in full seconds or keyword 1D (only some specific resolutions are supported)';

