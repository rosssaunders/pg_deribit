create or replace function deribit.test_public_get_last_trades_by_instrument()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_last_trades_by_instrument_response_result;
    
	_instrument_name text;
	_start_seq bigint = null;
	_end_seq bigint = null;
	_start_timestamp bigint = null;
	_end_timestamp bigint = null;
	_count bigint = null;
	_sorting deribit.public_get_last_trades_by_instrument_request_sorting = null;

begin
    _expected := deribit.public_get_last_trades_by_instrument(
		instrument_name := _instrument_name,
		start_seq := _start_seq,
		end_seq := _end_seq,
		start_timestamp := _start_timestamp,
		end_timestamp := _end_timestamp,
		count := _count,
		sorting := _sorting
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

