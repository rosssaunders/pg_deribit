create type deribit.private_get_current_deposit_address_response_result as (
	address text,
	creation_timestamp bigint,
	currency text,
	type text
);
comment on column deribit.private_get_current_deposit_address_response_result.address is 'Address in proper format for currency';
comment on column deribit.private_get_current_deposit_address_response_result.creation_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_current_deposit_address_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_current_deposit_address_response_result.type is 'Address type/purpose, allowed values : deposit, withdrawal, transfer';

create type deribit.private_get_current_deposit_address_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_current_deposit_address_response_result
);
comment on column deribit.private_get_current_deposit_address_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_current_deposit_address_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_current_deposit_address_response.result is 'Object if address is created, null otherwise';

create type deribit.private_get_current_deposit_address_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_current_deposit_address_request as (
	currency deribit.private_get_current_deposit_address_request_currency
);
comment on column deribit.private_get_current_deposit_address_request.currency is '(Required) The currency symbol';

create or replace function deribit.private_get_current_deposit_address(
	currency deribit.private_get_current_deposit_address_request_currency
)
returns deribit.private_get_current_deposit_address_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_current_deposit_address_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency
    )::deribit.private_get_current_deposit_address_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/get_current_deposit_address', _request));

    return (jsonb_populate_record(
        null::deribit.private_get_current_deposit_address_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_get_current_deposit_address is 'Retrieve deposit address for currency';

