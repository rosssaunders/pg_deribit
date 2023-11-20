create or replace function deribit.test_private_cancel_all_by_instrument()
returns setof text
language plpgsql
as $$
declare
    _expected float;
    
	_instrument_name text;
	_type deribit.private_cancel_all_by_instrument_request_type = null;
	_detailed boolean = null;
	_include_combos boolean = null;

begin
    _expected := deribit.private_cancel_all_by_instrument(
		instrument_name := _instrument_name,
		type := _type,
		detailed := _detailed,
		include_combos := _include_combos
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

