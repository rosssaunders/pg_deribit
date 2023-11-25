drop type if exists deribit.public_get_funding_rate_history_response_result cascade;
create type deribit.public_get_funding_rate_history_response_result as (
	index_price double precision,
	interest_1h double precision,
	interest_8h double precision,
	prev_index_price double precision,
	timestamp bigint
);
comment on column deribit.public_get_funding_rate_history_response_result.index_price is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result.interest_1h is '1hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result.interest_8h is '8hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result.prev_index_price is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

drop type if exists deribit.public_get_funding_rate_history_response cascade;
create type deribit.public_get_funding_rate_history_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_funding_rate_history_response_result[]
);
comment on column deribit.public_get_funding_rate_history_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_history_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_funding_rate_history_request cascade;
create type deribit.public_get_funding_rate_history_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
);
comment on column deribit.public_get_funding_rate_history_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_history_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_history_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

