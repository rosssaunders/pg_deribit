create or replace function deribit.test_private_get_margins()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_margins_response_result;
    
	_instrument_name text;
	_amount float;
	_price float;

begin
    _expected := deribit.private_get_margins(
		instrument_name := _instrument_name,
		amount := _amount,
		price := _price
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

