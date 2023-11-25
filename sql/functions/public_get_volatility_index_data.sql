drop function if exists deribit.public_get_volatility_index_data;

create or replace function deribit.public_get_volatility_index_data(
	currency deribit.public_get_volatility_index_data_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_volatility_index_data_request_resolution
)
returns deribit.public_get_volatility_index_data_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_volatility_index_data_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		start_timestamp,
		end_timestamp,
		resolution
    )::deribit.public_get_volatility_index_data_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_volatility_index_data'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.public_get_volatility_index_data_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_volatility_index_data is 'Public market data request for volatility index candles.';

