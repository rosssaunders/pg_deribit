create or replace function deribit.test_private_get_order_history_by_instrument()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_order_history_by_instrument_response_result;
    
	_instrument_name text;
	_count bigint = null;
	_"offset" bigint = null;
	_include_old boolean = null;
	_include_unfilled boolean = null;

begin
    _expected := deribit.private_get_order_history_by_instrument(
		instrument_name := _instrument_name,
		count := _count,
		"offset" := _"offset",
		include_old := _include_old,
		include_unfilled := _include_unfilled
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

