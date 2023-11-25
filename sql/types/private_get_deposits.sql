drop type if exists deribit.private_get_deposits_response_datum cascade;
create type deribit.private_get_deposits_response_datum as (
	address text,
	amount double precision,
	currency text,
	received_timestamp bigint,
	state text,
	transaction_id text,
	updated_timestamp bigint
);
comment on column deribit.private_get_deposits_response_datum.address is 'Address in proper format for currency';
comment on column deribit.private_get_deposits_response_datum.amount is 'Amount of funds in given currency';
comment on column deribit.private_get_deposits_response_datum.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_deposits_response_datum.received_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_deposits_response_datum.state is 'Deposit state, allowed values : pending, completed, rejected, replaced';
comment on column deribit.private_get_deposits_response_datum.transaction_id is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_get_deposits_response_datum.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

drop type if exists deribit.private_get_deposits_response_result cascade;
create type deribit.private_get_deposits_response_result as (
	count bigint,
	data deribit.private_get_deposits_response_datum[]
);
comment on column deribit.private_get_deposits_response_result.count is 'Total number of results available';

drop type if exists deribit.private_get_deposits_response cascade;
create type deribit.private_get_deposits_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_deposits_response_result
);
comment on column deribit.private_get_deposits_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_deposits_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_get_deposits_request_currency cascade;
create type deribit.private_get_deposits_request_currency as enum ('BTC', 'ETH', 'USDC');

drop type if exists deribit.private_get_deposits_request cascade;
create type deribit.private_get_deposits_request as (
	currency deribit.private_get_deposits_request_currency,
	count bigint,
	"offset" bigint
);
comment on column deribit.private_get_deposits_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_deposits_request.count is 'Number of requested items, default - 10';
comment on column deribit.private_get_deposits_request."offset" is 'The offset for pagination, default - 0';

