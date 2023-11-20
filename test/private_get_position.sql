create or replace function deribit.test_private_get_position()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_position_response_result;
    
	_instrument_name text;

begin
    _expected := deribit.private_get_position(
		instrument_name := _instrument_name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

