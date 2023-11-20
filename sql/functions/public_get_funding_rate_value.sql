drop function if exists deribit.public_get_funding_rate_value;
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
    
    perform deribit.matching_engine_request_log_call('/public/get_funding_rate_value');
    
_request := row(
		instrument_name,
		start_timestamp,
		end_timestamp
    )::deribit.public_get_funding_rate_value_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_funding_rate_value', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_funding_rate_value_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_funding_rate_value is 'Retrieves interest rate value for requested period. Applicable only for PERPETUAL instruments.';

