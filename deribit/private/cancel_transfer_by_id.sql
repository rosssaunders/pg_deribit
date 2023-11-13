insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/cancel_transfer_by_id', now(), 0, '0 secs'::interval);

create type deribit.private_cancel_transfer_by_id_response_result as (
	amount float,
	created_timestamp bigint,
	currency text,
	direction text,
	id bigint,
	other_side text,
	state text,
	type text,
	updated_timestamp bigint
);
comment on column deribit.private_cancel_transfer_by_id_response_result.amount is 'Amount of funds in given currency';
comment on column deribit.private_cancel_transfer_by_id_response_result.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_transfer_by_id_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_cancel_transfer_by_id_response_result.direction is 'Transfer direction';
comment on column deribit.private_cancel_transfer_by_id_response_result.id is 'Id of transfer';
comment on column deribit.private_cancel_transfer_by_id_response_result.other_side is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_cancel_transfer_by_id_response_result.state is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_cancel_transfer_by_id_response_result.type is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_cancel_transfer_by_id_response_result.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_cancel_transfer_by_id_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_cancel_transfer_by_id_response_result
);
comment on column deribit.private_cancel_transfer_by_id_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_transfer_by_id_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_cancel_transfer_by_id_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_cancel_transfer_by_id_request as (
	currency deribit.private_cancel_transfer_by_id_request_currency,
	id bigint
);
comment on column deribit.private_cancel_transfer_by_id_request.currency is '(Required) The currency symbol';
comment on column deribit.private_cancel_transfer_by_id_request.id is '(Required) Id of transfer';

create or replace function deribit.private_cancel_transfer_by_id(
	currency deribit.private_cancel_transfer_by_id_request_currency,
	id bigint
)
returns deribit.private_cancel_transfer_by_id_response_result
language plpgsql
as $$
declare
	_request deribit.private_cancel_transfer_by_id_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		id
    )::deribit.private_cancel_transfer_by_id_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_transfer_by_id', _request);

    return (jsonb_populate_record(
        null::deribit.private_cancel_transfer_by_id_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_transfer_by_id is 'Cancel transfer';

