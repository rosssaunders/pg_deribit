create or replace function deribit.test_private_close_position()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_close_position_response_result;
    
	_instrument_name text;
	_type deribit.private_close_position_request_type;
	_price float = null;

begin
    _expected := deribit.private_close_position(
		instrument_name := _instrument_name,
		type := _type,
		price := _price
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

