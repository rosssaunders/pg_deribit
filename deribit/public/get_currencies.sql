insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_currencies', null, 0, '0 secs'::interval);

create type deribit.public_get_currencies_response_withdrawal_priority as (
	name text,
	value float
);


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

create type deribit.public_get_currencies_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_currencies_response_result[]
);
comment on column deribit.public_get_currencies_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_currencies_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.public_get_currencies()
returns setof deribit.public_get_currencies_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= deribit.internal_jsonrpc_request('/public/get_currencies');

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.public_get_currencies_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.public_get_currencies is 'Retrieves all cryptocurrencies supported by the API.';

