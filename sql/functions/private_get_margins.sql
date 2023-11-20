drop function if exists deribit.private_get_margins;
create or replace function deribit.private_get_margins(
	instrument_name text,
	amount float,
	price float
)
returns deribit.private_get_margins_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_margins_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_margins');
    
_request := row(
		instrument_name,
		amount,
		price
    )::deribit.private_get_margins_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_margins', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_margins_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_margins is 'Get margins for given instrument, amount and price.';

