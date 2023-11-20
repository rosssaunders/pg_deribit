create or replace function deribit.test_public_get_last_settlements_by_instrument()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_last_settlements_by_instrument_response_result;
    
	_instrument_name text;
	_type deribit.public_get_last_settlements_by_instrument_request_type = null;
	_count bigint = null;
	_continuation text = null;
	_search_start_timestamp bigint = null;

begin
    _expected := deribit.public_get_last_settlements_by_instrument(
		instrument_name := _instrument_name,
		type := _type,
		count := _count,
		continuation := _continuation,
		search_start_timestamp := _search_start_timestamp
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

