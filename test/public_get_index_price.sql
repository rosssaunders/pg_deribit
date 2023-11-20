create or replace function deribit.test_public_get_index_price()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_index_price_response_result;
    
	_index_name deribit.public_get_index_price_request_index_name;

begin
    _expected := deribit.public_get_index_price(
		index_name := _index_name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

