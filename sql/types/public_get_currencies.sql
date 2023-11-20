drop type if exists deribit.public_get_currencies_response_withdrawal_priority cascade;
create type deribit.public_get_currencies_response_withdrawal_priority as (
	name text,
	value float
);


drop type if exists deribit.public_get_currencies_response_result cascade;
create type deribit.public_get_currencies_response_result as (
	coin_type text,
	currency text,
	currency_long text,
	fee_precision bigint,
	min_confirmations bigint,
	min_withdrawal_fee float,
	withdrawal_fee float,
	withdrawal_priorities deribit.public_get_currencies_response_withdrawal_priority[]
);
comment on column deribit.public_get_currencies_response_result.coin_type is 'The type of the currency.';
comment on column deribit.public_get_currencies_response_result.currency is 'The abbreviation of the currency. This abbreviation is used elsewhere in the API to identify the currency.';
comment on column deribit.public_get_currencies_response_result.currency_long is 'The full name for the currency.';
comment on column deribit.public_get_currencies_response_result.fee_precision is 'fee precision';
comment on column deribit.public_get_currencies_response_result.min_confirmations is 'Minimum number of block chain confirmations before deposit is accepted.';
comment on column deribit.public_get_currencies_response_result.min_withdrawal_fee is 'The minimum transaction fee paid for withdrawals';
comment on column deribit.public_get_currencies_response_result.withdrawal_fee is 'The total transaction fee paid for withdrawals';

drop type if exists deribit.public_get_currencies_response cascade;
create type deribit.public_get_currencies_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_currencies_response_result[]
);
comment on column deribit.public_get_currencies_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_currencies_response.jsonrpc is 'The JSON-RPC version (2.0)';

