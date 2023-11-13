insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_index', now(), 0, '0 secs'::interval);

create type deribit.public_get_index_response_result as (
	BTC float,
	ETH float,
	edp float
);
comment on column deribit.public_get_index_response_result.BTC is 'The current index price for BTC-USD (only for selected currency == BTC)';
comment on column deribit.public_get_index_response_result.ETH is 'The current index price for ETH-USD (only for selected currency == ETH)';
comment on column deribit.public_get_index_response_result.edp is 'Estimated delivery price for the currency. For more details, see Documentation > General > Expiration Price';

create type deribit.public_get_index_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_index_response_result
);
comment on column deribit.public_get_index_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_index_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_index_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.public_get_index_request as (
	currency deribit.public_get_index_request_currency
);
comment on column deribit.public_get_index_request.currency is '(Required) The currency symbol';

create or replace function deribit.public_get_index(
	currency deribit.public_get_index_request_currency
)
returns deribit.public_get_index_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_index_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency
    )::deribit.public_get_index_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_index', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_index_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_index is 'Retrieves the current index price for the instruments, for the selected currency.';

