create or replace function deribit.test_public_get_book_summary_by_currency()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_book_summary_by_currency_response_result;
    
	_currency deribit.public_get_book_summary_by_currency_request_currency;
	_kind deribit.public_get_book_summary_by_currency_request_kind = null;

begin
    _expected := deribit.public_get_book_summary_by_currency(
		currency := _currency,
		kind := _kind
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

