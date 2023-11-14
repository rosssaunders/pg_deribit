insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_funding_rate_history', null, 0, '0 secs'::interval);

create type deribit.public_get_funding_rate_history_response_result as (
	index_price float,
	interest_1h float,
	interest_8h float,
	prev_index_price float,
	timestamp bigint
);
comment on column deribit.public_get_funding_rate_history_response_result.index_price is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result.interest_1h is '1hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result.interest_8h is '8hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result.prev_index_price is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.public_get_funding_rate_history_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_funding_rate_history_response_result[]
);
comment on column deribit.public_get_funding_rate_history_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_history_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_funding_rate_history_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
);
comment on column deribit.public_get_funding_rate_history_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_history_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_history_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create or replace function deribit.public_get_funding_rate_history(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns setof deribit.public_get_funding_rate_history_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_funding_rate_history_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		start_timestamp,
		end_timestamp
    )::deribit.public_get_funding_rate_history_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_funding_rate_history', _request);

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.public_get_funding_rate_history_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.public_get_funding_rate_history is 'Retrieves hourly historical interest rate for requested PERPETUAL instrument.';

