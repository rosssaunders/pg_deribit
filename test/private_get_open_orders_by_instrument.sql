create or replace function deribit.test_private_get_open_orders_by_instrument()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_open_orders_by_instrument_response_result;
    
	_instrument_name text;
	_type deribit.private_get_open_orders_by_instrument_request_type = null;

begin
    _expected := deribit.private_get_open_orders_by_instrument(
		instrument_name := _instrument_name,
		type := _type
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

