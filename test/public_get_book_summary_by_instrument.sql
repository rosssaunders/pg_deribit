create or replace function deribit.test_public_get_book_summary_by_instrument()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_book_summary_by_instrument_response_result;
    
	_instrument_name text;

begin
    _expected := deribit.public_get_book_summary_by_instrument(
		instrument_name := _instrument_name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

