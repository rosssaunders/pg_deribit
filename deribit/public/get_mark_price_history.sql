insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_mark_price_history', null, 0, '0 secs'::interval);

create type deribit.public_get_mark_price_history_response as (
	id bigint,
	jsonrpc text,
	result text[]
);
comment on column deribit.public_get_mark_price_history_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_mark_price_history_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_mark_price_history_response.result is 'Markprice history values as an array of arrays with 2 values each. The inner values correspond to the timestamp in ms and the markprice itself.';

create type deribit.public_get_mark_price_history_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
);
comment on column deribit.public_get_mark_price_history_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_mark_price_history_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_mark_price_history_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create or replace function deribit.public_get_mark_price_history(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns text[]
language plpgsql
as $$
declare
	_request deribit.public_get_mark_price_history_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		start_timestamp,
		end_timestamp
    )::deribit.public_get_mark_price_history_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_mark_price_history', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_mark_price_history_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_mark_price_history is 'Public request for 5min history of markprice values for the instrument. For now the markprice history is available only for a subset of options which take part in the volatility index calculations. All other instruments, futures and perpetuals will return empty list.';

