drop type if exists deribit.public_get_funding_chart_data_response_datum cascade;
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

drop type if exists deribit.public_get_funding_chart_data_response_result cascade;
create type deribit.public_get_funding_chart_data_response_result as (
	current_interest float,
	data deribit.public_get_funding_chart_data_response_datum[]
);
comment on column deribit.public_get_funding_chart_data_response_result.current_interest is 'Current interest';

drop type if exists deribit.public_get_funding_chart_data_response cascade;
create type deribit.public_get_funding_chart_data_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_funding_chart_data_response_result
);
comment on column deribit.public_get_funding_chart_data_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_funding_chart_data_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_funding_chart_data_request_length cascade;
create type deribit.public_get_funding_chart_data_request_length as enum ('1m', '24h', '8h');

drop type if exists deribit.public_get_funding_chart_data_request cascade;
create type deribit.public_get_funding_chart_data_request as (
	instrument_name text,
	length deribit.public_get_funding_chart_data_request_length
);
comment on column deribit.public_get_funding_chart_data_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_funding_chart_data_request.length is '(Required) Specifies time period. 8h - 8 hours, 24h - 24 hours, 1m - 1 month';

