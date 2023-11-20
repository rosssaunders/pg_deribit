create or replace function deribit.test_public_get_order_book()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_order_book_response_result;
    
	_instrument_name text;
	_depth deribit.public_get_order_book_request_depth = null;

begin
    _expected := deribit.public_get_order_book(
		instrument_name := _instrument_name,
		depth := _depth
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

