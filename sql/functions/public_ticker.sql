drop function if exists deribit.public_ticker;

create or replace function deribit.public_ticker(
	instrument_name text
)
returns deribit.public_ticker_response_result
language plpgsql
as $$
declare
	_request deribit.public_ticker_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name
    )::deribit.public_ticker_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/ticker'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.public_ticker_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_ticker is 'Get ticker for an instrument.';

