create type deribit.private_cancel_withdrawal_response_result as (
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
comment on column deribit.private_cancel_withdrawal_response_result.address is 'Address in proper format for currency';
comment on column deribit.private_cancel_withdrawal_response_result.amount is 'Amount of funds in given currency';
comment on column deribit.private_cancel_withdrawal_response_result.confirmed_timestamp is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_cancel_withdrawal_response_result.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_withdrawal_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_cancel_withdrawal_response_result.fee is 'Fee in currency';
comment on column deribit.private_cancel_withdrawal_response_result.id is 'Withdrawal id in Deribit system';
comment on column deribit.private_cancel_withdrawal_response_result.priority is 'Id of priority level';
comment on column deribit.private_cancel_withdrawal_response_result.state is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_cancel_withdrawal_response_result.transaction_id is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_cancel_withdrawal_response_result.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_cancel_withdrawal_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_cancel_withdrawal_response_result
);
comment on column deribit.private_cancel_withdrawal_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_withdrawal_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_cancel_withdrawal_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_cancel_withdrawal_request as (
	currency deribit.private_cancel_withdrawal_request_currency,
	id float
);
comment on column deribit.private_cancel_withdrawal_request.currency is '(Required) The currency symbol';
comment on column deribit.private_cancel_withdrawal_request.id is '(Required) The withdrawal id';

create or replace function deribit.private_cancel_withdrawal(
	currency deribit.private_cancel_withdrawal_request_currency,
	id float
)
returns deribit.private_cancel_withdrawal_response_result
language plpgsql
as $$
declare
	_request deribit.private_cancel_withdrawal_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		id
    )::deribit.private_cancel_withdrawal_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/cancel_withdrawal', _request));

    return (jsonb_populate_record(
        null::deribit.private_cancel_withdrawal_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_cancel_withdrawal is 'Cancels withdrawal request';

