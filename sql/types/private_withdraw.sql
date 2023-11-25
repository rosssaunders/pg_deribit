drop type if exists deribit.private_withdraw_response_result cascade;
create type deribit.private_withdraw_response_result as (
	address text,
	amount float,
	confirmed_timestamp bigint,
	created_timestamp bigint,
	currency text,
	fee float,
	id bigint,
	priority float,
	state text,
	transaction_id text,
	updated_timestamp bigint
);
comment on column deribit.private_withdraw_response_result.address is 'Address in proper format for currency';
comment on column deribit.private_withdraw_response_result.amount is 'Amount of funds in given currency';
comment on column deribit.private_withdraw_response_result.confirmed_timestamp is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_withdraw_response_result.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_withdraw_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_withdraw_response_result.fee is 'Fee in currency';
comment on column deribit.private_withdraw_response_result.id is 'Withdrawal id in Deribit system';
comment on column deribit.private_withdraw_response_result.priority is 'Id of priority level';
comment on column deribit.private_withdraw_response_result.state is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_withdraw_response_result.transaction_id is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_withdraw_response_result.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

drop type if exists deribit.private_withdraw_response cascade;
create type deribit.private_withdraw_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_withdraw_response_result
);
comment on column deribit.private_withdraw_response.id is 'The id that was sent in the request';
comment on column deribit.private_withdraw_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_withdraw_request_currency cascade;
create type deribit.private_withdraw_request_currency as enum ('BTC', 'USDC', 'ETH');

drop type if exists deribit.private_withdraw_request_priority cascade;
create type deribit.private_withdraw_request_priority as enum ('very_high', 'insane', 'extreme_high', 'low', 'high', 'very_low', 'mid');

drop type if exists deribit.private_withdraw_request cascade;
create type deribit.private_withdraw_request as (
	currency deribit.private_withdraw_request_currency,
	address text,
	amount float,
	priority deribit.private_withdraw_request_priority
);
comment on column deribit.private_withdraw_request.currency is '(Required) The currency symbol';
comment on column deribit.private_withdraw_request.address is '(Required) Address in currency format, it must be in address book';
comment on column deribit.private_withdraw_request.amount is '(Required) Amount of funds to be withdrawn';
comment on column deribit.private_withdraw_request.priority is 'Withdrawal priority, optional for BTC, default: high';

