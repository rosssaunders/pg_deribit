insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_delivery_prices', now(), 0, '0 secs'::interval);

create type deribit.public_get_delivery_prices_response_datum as (
	date text,
	delivery_price float,
	records_total float
);
comment on column deribit.public_get_delivery_prices_response_datum.date is 'The event date with year, month and day';
comment on column deribit.public_get_delivery_prices_response_datum.delivery_price is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_get_delivery_prices_response_datum.records_total is 'Available delivery prices';

create type deribit.public_get_delivery_prices_response_result as (
	data deribit.public_get_delivery_prices_response_datum[]
);


create type deribit.public_get_delivery_prices_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_delivery_prices_response_result
);
comment on column deribit.public_get_delivery_prices_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_delivery_prices_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_delivery_prices_request_index_name as enum ('ada_usd', 'algo_usd', 'avax_usd', 'bch_usd', 'btc_usd', 'doge_usd', 'dot_usd', 'eth_usd', 'link_usd', 'ltc_usd', 'matic_usd', 'near_usd', 'shib_usd', 'sol_usd', 'trx_usd', 'uni_usd', 'usdc_usd', 'xrp_usd', 'ada_usdc', 'bch_usdc', 'algo_usdc', 'avax_usdc', 'btc_usdc', 'doge_usdc', 'dot_usdc', 'bch_usdc', 'eth_usdc', 'link_usdc', 'ltc_usdc', 'matic_usdc', 'near_usdc', 'shib_usdc', 'sol_usdc', 'trx_usdc', 'uni_usdc', 'xrp_usdc', 'btcdvol_usdc', 'ethdvol_usdc');

create type deribit.public_get_delivery_prices_request as (
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint,
	count bigint
);
comment on column deribit.public_get_delivery_prices_request.index_name is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.public_get_delivery_prices_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.public_get_delivery_prices_request.count is 'Number of requested items, default - 10';

create or replace function deribit.public_get_delivery_prices(
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint default null,
	count bigint default null
)
returns deribit.public_get_delivery_prices_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_delivery_prices_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		index_name,
		"offset",
		count
    )::deribit.public_get_delivery_prices_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_delivery_prices', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_delivery_prices_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_delivery_prices is 'Retrives delivery prices for then given index';

