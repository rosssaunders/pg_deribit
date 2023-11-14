insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/withdraw', null, 0, '0 secs'::interval);

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

create type deribit.private_withdraw_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_withdraw_response_result
);
comment on column deribit.private_withdraw_response.id is 'The id that was sent in the request';
comment on column deribit.private_withdraw_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_withdraw_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_withdraw_request_priority as enum ('insane', 'extreme_high', 'very_high', 'high', 'mid', 'low', 'very_low');

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

create or replace function deribit.private_withdraw(
	currency deribit.private_withdraw_request_currency,
	address text,
	amount float,
	priority deribit.private_withdraw_request_priority default null
)
returns deribit.private_withdraw_response_result
language plpgsql
as $$
declare
	_request deribit.private_withdraw_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		address,
		amount,
		priority
    )::deribit.private_withdraw_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/withdraw', _request);

    return (jsonb_populate_record(
        null::deribit.private_withdraw_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_withdraw is 'Creates a new withdrawal request';

