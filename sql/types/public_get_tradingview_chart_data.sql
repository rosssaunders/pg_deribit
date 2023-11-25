drop type if exists deribit.public_get_tradingview_chart_data_response_result cascade;
create type deribit.public_get_tradingview_chart_data_response_result as (
	close double precision[],
	cost double precision[],
	high double precision[],
	low double precision[],
	open double precision[],
	status text,
	ticks bigint[],
	volume double precision[]
);
comment on column deribit.public_get_tradingview_chart_data_response_result.close is 'List of prices at close (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.cost is 'List of cost bars (volume in quote currency, one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.high is 'List of highest price levels (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.low is 'List of lowest price levels (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.open is 'List of prices at open (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result.status is 'Status of the query: ok or no_data';
comment on column deribit.public_get_tradingview_chart_data_response_result.ticks is 'Values of the time axis given in milliseconds since UNIX epoch';
comment on column deribit.public_get_tradingview_chart_data_response_result.volume is 'List of volume bars (in base currency, one per candle)';

drop type if exists deribit.public_get_tradingview_chart_data_response cascade;
create type deribit.public_get_tradingview_chart_data_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_tradingview_chart_data_response_result
);
comment on column deribit.public_get_tradingview_chart_data_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_tradingview_chart_data_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_tradingview_chart_data_request_resolution cascade;
create type deribit.public_get_tradingview_chart_data_request_resolution as enum ('1', '10', '120', '15', '180', '1D', '3', '30', '360', '5', '60', '720');

drop type if exists deribit.public_get_tradingview_chart_data_request cascade;
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

