drop type if exists deribit.public_get_mark_price_history_response_result cascade;
create type deribit.public_get_mark_price_history_response_result as (

);


drop type if exists deribit.public_get_mark_price_history_response cascade;
create type deribit.public_get_mark_price_history_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_mark_price_history_response_result[]
);
comment on column deribit.public_get_mark_price_history_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_mark_price_history_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_mark_price_history_response.result is 'Markprice history values as an array of arrays with 2 values each. The inner values correspond to the timestamp in ms and the markprice itself.';

drop type if exists deribit.public_get_mark_price_history_request cascade;
create type deribit.public_get_mark_price_history_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
);
comment on column deribit.public_get_mark_price_history_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_mark_price_history_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_mark_price_history_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

