create or replace function deribit.public_get_index_price(
	index_name deribit.public_get_index_price_request_index_name
)
returns deribit.public_get_index_price_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_index_price_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		index_name
    )::deribit.public_get_index_price_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_index_price', _request);

    perform deribit.matching_engine_request_log_call('/public/get_index_price');

    return (jsonb_populate_record(
        null::deribit.public_get_index_price_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_index_price is 'Retrieves the current index price value for given index name.';

