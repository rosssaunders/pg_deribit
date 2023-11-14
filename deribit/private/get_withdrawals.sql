insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_withdrawals', null, 0, '0 secs'::interval);

create type deribit.private_get_withdrawals_response_datum as (
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
comment on column deribit.private_get_withdrawals_response_datum.address is 'Address in proper format for currency';
comment on column deribit.private_get_withdrawals_response_datum.amount is 'Amount of funds in given currency';
comment on column deribit.private_get_withdrawals_response_datum.confirmed_timestamp is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_get_withdrawals_response_datum.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_withdrawals_response_datum.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_withdrawals_response_datum.fee is 'Fee in currency';
comment on column deribit.private_get_withdrawals_response_datum.id is 'Withdrawal id in Deribit system';
comment on column deribit.private_get_withdrawals_response_datum.priority is 'Id of priority level';
comment on column deribit.private_get_withdrawals_response_datum.state is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_get_withdrawals_response_datum.transaction_id is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_get_withdrawals_response_datum.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_withdrawals_response_result as (
	count bigint,
	data deribit.private_get_withdrawals_response_datum[]
);
comment on column deribit.private_get_withdrawals_response_result.count is 'Total number of results available';

create type deribit.private_get_withdrawals_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_withdrawals_response_result
);
comment on column deribit.private_get_withdrawals_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_withdrawals_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_withdrawals_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_withdrawals_request as (
	currency deribit.private_get_withdrawals_request_currency,
	count bigint,
	"offset" bigint
);
comment on column deribit.private_get_withdrawals_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_withdrawals_request.count is 'Number of requested items, default - 10';
comment on column deribit.private_get_withdrawals_request."offset" is 'The offset for pagination, default - 0';

create or replace function deribit.private_get_withdrawals(
	currency deribit.private_get_withdrawals_request_currency,
	count bigint default null,
	"offset" bigint default null
)
returns deribit.private_get_withdrawals_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_withdrawals_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		count,
		"offset"
    )::deribit.private_get_withdrawals_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_withdrawals', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_withdrawals_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_withdrawals is 'Retrieve the latest users withdrawals';

