insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_index_price', null, 0, '0 secs'::interval);

create type deribit.public_get_index_price_response_result as (
	estimated_delivery_price float,
	index_price float
);
comment on column deribit.public_get_index_price_response_result.estimated_delivery_price is 'Estimated delivery price for the market. For more details, see Documentation > General > Expiration Price';
comment on column deribit.public_get_index_price_response_result.index_price is 'Value of requested index';

create type deribit.public_get_index_price_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_index_price_response_result
);
comment on column deribit.public_get_index_price_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_index_price_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_index_price_request_index_name as enum ('ada_usd', 'algo_usd', 'avax_usd', 'bch_usd', 'btc_usd', 'doge_usd', 'dot_usd', 'eth_usd', 'link_usd', 'ltc_usd', 'matic_usd', 'near_usd', 'shib_usd', 'sol_usd', 'trx_usd', 'uni_usd', 'usdc_usd', 'xrp_usd', 'ada_usdc', 'bch_usdc', 'algo_usdc', 'avax_usdc', 'btc_usdc', 'doge_usdc', 'dot_usdc', 'bch_usdc', 'eth_usdc', 'link_usdc', 'ltc_usdc', 'matic_usdc', 'near_usdc', 'shib_usdc', 'sol_usdc', 'trx_usdc', 'uni_usdc', 'xrp_usdc', 'btcdvol_usdc', 'ethdvol_usdc');

create type deribit.public_get_index_price_request as (
	index_name deribit.public_get_index_price_request_index_name
);
comment on column deribit.public_get_index_price_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

create or replace function deribit.public_get_index_price(
	index_name deribit.public_get_index_price_request_index_name
)
returns deribit.public_get_index_price_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_index_price_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		index_name
    )::deribit.public_get_index_price_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_index_price', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_index_price_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_index_price is 'Retrieves the current index price value for given index name.';

