drop type if exists deribit.public_get_index_response_result cascade;
create type deribit.public_get_index_response_result as (
	BTC float,
	ETH float,
	edp float
);
comment on column deribit.public_get_index_response_result.BTC is 'The current index price for BTC-USD (only for selected currency == BTC)';
comment on column deribit.public_get_index_response_result.ETH is 'The current index price for ETH-USD (only for selected currency == ETH)';
comment on column deribit.public_get_index_response_result.edp is 'Estimated delivery price for the currency. For more details, see Documentation > General > Expiration Price';

drop type if exists deribit.public_get_index_response cascade;
create type deribit.public_get_index_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_index_response_result
);
comment on column deribit.public_get_index_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_index_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_index_request_currency cascade;
create type deribit.public_get_index_request_currency as enum ('USDC', 'ETH', 'BTC');

drop type if exists deribit.public_get_index_request cascade;
create type deribit.public_get_index_request as (
	currency deribit.public_get_index_request_currency
);
comment on column deribit.public_get_index_request.currency is '(Required) The currency symbol';

