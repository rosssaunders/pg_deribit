create or replace function deribit.test_public_get_funding_rate_value()
returns setof text
language plpgsql
as $$
declare
    _expected float;
    
	_instrument_name text;
	_start_timestamp bigint;
	_end_timestamp bigint;

begin
    _expected := deribit.public_get_funding_rate_value(
		instrument_name := _instrument_name,
		start_timestamp := _start_timestamp,
		end_timestamp := _end_timestamp
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

