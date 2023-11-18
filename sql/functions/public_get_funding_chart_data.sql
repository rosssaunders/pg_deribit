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

    perform deribit.matching_engine_request_log_call('/public/get_funding_chart_data');

    return (jsonb_populate_record(
        null::deribit.public_get_funding_chart_data_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_funding_chart_data is 'Retrieve the list of the latest PERPETUAL funding chart points within a given time period.';

