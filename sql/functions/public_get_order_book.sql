drop function if exists deribit.public_get_order_book;
create or replace function deribit.public_get_order_book(
	instrument_name text,
	depth deribit.public_get_order_book_request_depth default null
)
returns deribit.public_get_order_book_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_order_book_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_order_book');
    
_request := row(
		instrument_name,
		depth
    )::deribit.public_get_order_book_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_order_book', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_order_book_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_order_book is 'Retrieves the order book, along with other market values for a given instrument.';

