create or replace function deribit.test_public_get_order_book_by_instrument_id()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_order_book_by_instrument_id_response_result;
    
	_instrument_id bigint;
	_depth deribit.public_get_order_book_by_instrument_id_request_depth = null;

begin
    _expected := deribit.public_get_order_book_by_instrument_id(
		instrument_id := _instrument_id,
		depth := _depth
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

