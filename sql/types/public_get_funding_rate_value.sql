drop type if exists deribit.public_get_funding_rate_value_response cascade;
create type deribit.public_get_funding_rate_value_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.public_get_funding_rate_value_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_value_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_funding_rate_value_request cascade;
create type deribit.public_get_funding_rate_value_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
);
comment on column deribit.public_get_funding_rate_value_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_value_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_value_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

