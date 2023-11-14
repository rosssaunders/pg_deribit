insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_volatility_index_data', null, 0, '0 secs'::interval);

create type deribit.public_get_volatility_index_data_response_result as (
	continuation bigint,
	data text[]
);
comment on column deribit.public_get_volatility_index_data_response_result.continuation is 'Continuation - to be used as the end_timestamp parameter on the next request. NULL when no continuation.';
comment on column deribit.public_get_volatility_index_data_response_result.data is 'Candles as an array of arrays with 5 values each. The inner values correspond to the timestamp in ms, open, high, low, and close values of the volatility index correspondingly.';

create type deribit.public_get_volatility_index_data_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_volatility_index_data_response_result
);
comment on column deribit.public_get_volatility_index_data_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_volatility_index_data_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_volatility_index_data_response.result is 'Volatility index candles.';

create type deribit.public_get_volatility_index_data_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.public_get_volatility_index_data_request_resolution as enum ('1', '60', '3600', '43200', '1D');

create type deribit.public_get_volatility_index_data_request as (
	currency deribit.public_get_volatility_index_data_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_volatility_index_data_request_resolution
);
comment on column deribit.public_get_volatility_index_data_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_volatility_index_data_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_volatility_index_data_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_volatility_index_data_request.resolution is '(Required) Time resolution given in full seconds or keyword 1D (only some specific resolutions are supported)';

create or replace function deribit.public_get_volatility_index_data(
	currency deribit.public_get_volatility_index_data_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_volatility_index_data_request_resolution
)
returns deribit.public_get_volatility_index_data_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_volatility_index_data_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		start_timestamp,
		end_timestamp,
		resolution
    )::deribit.public_get_volatility_index_data_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_volatility_index_data', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_volatility_index_data_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_volatility_index_data is 'Public market data request for volatility index candles.';

