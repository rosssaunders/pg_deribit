insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_tradingview_chart_data', null, 0, '0 secs'::interval);

create type deribit.public_get_tradingview_chart_data_response_result as (
	close UNKNOWN - array of number,
	cost UNKNOWN - array of number,
	high UNKNOWN - array of number,
	low UNKNOWN - array of number,
	open UNKNOWN - array of number,
	status text,
	ticks UNKNOWN - array of integer,
	volume UNKNOWN - array of number
);
comment on column deribit.public_get_tradingview_chart_data_response_result.close is 'List of prices at close (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.cost is 'List of cost bars (volume in quote currency, one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.high is 'List of highest price levels (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.low is 'List of lowest price levels (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.open is 'List of prices at open (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.status is 'Status of the query: ok or no_data';
comment on column deribit.public_get_tradingview_chart_data_response_result.ticks is 'Values of the time axis given in milliseconds since UNIX epoch';
comment on column deribit.public_get_tradingview_chart_data_response_result.volume is 'List of volume bars (in base currency, one per candle)';

create type deribit.public_get_tradingview_chart_data_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_tradingview_chart_data_response_result
);
comment on column deribit.public_get_tradingview_chart_data_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_tradingview_chart_data_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_tradingview_chart_data_request_resolution as enum ('1', '3', '5', '10', '15', '30', '60', '120', '180', '360', '720', '1D');

create type deribit.public_get_tradingview_chart_data_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_tradingview_chart_data_request_resolution
);
comment on column deribit.public_get_tradingview_chart_data_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_tradingview_chart_data_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_tradingview_chart_data_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_tradingview_chart_data_request.resolution is '(Required) Chart bars resolution given in full minutes or keyword 1D (only some specific resolutions are supported)';

create or replace function deribit.public_get_tradingview_chart_data(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_tradingview_chart_data_request_resolution
)
returns deribit.public_get_tradingview_chart_data_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_tradingview_chart_data_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		start_timestamp,
		end_timestamp,
		resolution
    )::deribit.public_get_tradingview_chart_data_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_tradingview_chart_data', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_tradingview_chart_data_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_tradingview_chart_data is 'Publicly available market data used to generate a TradingView candle chart.';

