insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_funding_chart_data', null, 0, '0 secs'::interval);

create type deribit.public_get_funding_chart_data_response_datum as (
	index_price float,
	interest_8h float,
	timestamp bigint,
	interest_8h float
);
comment on column deribit.public_get_funding_chart_data_response_datum.index_price is 'Current index price';
comment on column deribit.public_get_funding_chart_data_response_datum.interest_8h is 'Historical interest 8h value';
comment on column deribit.public_get_funding_chart_data_response_datum.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_funding_chart_data_response_datum.interest_8h is 'Current interest 8h';

create type deribit.public_get_funding_chart_data_response_result as (
	current_interest float,
	data deribit.public_get_funding_chart_data_response_datum[]
);
comment on column deribit.public_get_funding_chart_data_response_result.current_interest is 'Current interest';

create type deribit.public_get_funding_chart_data_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_funding_chart_data_response_result
);
comment on column deribit.public_get_funding_chart_data_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_funding_chart_data_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_funding_chart_data_request_length as enum ('8h', '24h', '1m');

create type deribit.public_get_funding_chart_data_request as (
	instrument_name text,
	length deribit.public_get_funding_chart_data_request_length
);
comment on column deribit.public_get_funding_chart_data_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_funding_chart_data_request.length is '(Required) Specifies time period. 8h - 8 hours, 24h - 24 hours, 1m - 1 month';

create or replace function deribit.public_get_funding_chart_data(
	instrument_name text,
	length deribit.public_get_funding_chart_data_request_length
)
returns deribit.public_get_funding_chart_data_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_funding_chart_data_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		length
    )::deribit.public_get_funding_chart_data_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_funding_chart_data', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_funding_chart_data_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_funding_chart_data is 'Retrieve the list of the latest PERPETUAL funding chart points within a given time period.';

