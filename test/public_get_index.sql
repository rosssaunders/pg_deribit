create or replace function deribit.test_public_get_index()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_index_response_result;
    
	_currency deribit.public_get_index_request_currency;

begin
    _expected := deribit.public_get_index(
		currency := _currency
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

