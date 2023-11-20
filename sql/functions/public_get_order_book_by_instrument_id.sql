drop function if exists deribit.public_get_order_book_by_instrument_id;
create or replace function deribit.public_get_order_book_by_instrument_id(
	instrument_id bigint,
	depth deribit.public_get_order_book_by_instrument_id_request_depth default null
)
returns deribit.public_get_order_book_by_instrument_id_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_order_book_by_instrument_id_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_order_book_by_instrument_id');
    
_request := row(
		instrument_id,
		depth
    )::deribit.public_get_order_book_by_instrument_id_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_order_book_by_instrument_id', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_order_book_by_instrument_id_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_order_book_by_instrument_id is 'Retrieves the order book, along with other market values for a given instrument ID.';

