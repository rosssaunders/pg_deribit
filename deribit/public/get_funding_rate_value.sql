create type deribit.public_get_funding_rate_value_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.public_get_funding_rate_value_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_value_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_funding_rate_value_request as (
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
);
comment on column deribit.public_get_funding_rate_value_request.instrument_name is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_value_request.start_timestamp is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_value_request.end_timestamp is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create or replace function deribit.public_get_funding_rate_value(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns float
language plpgsql
as $$
declare
	_request deribit.public_get_funding_rate_value_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		start_timestamp,
		end_timestamp
    )::deribit.public_get_funding_rate_value_request;
    
    _http_response := (select deribit.jsonrpc_request('/public/get_funding_rate_value', _request));

    return (jsonb_populate_record(
        null::deribit.public_get_funding_rate_value_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_funding_rate_value is 'Retrieves interest rate value for requested period. Applicable only for PERPETUAL instruments.';

