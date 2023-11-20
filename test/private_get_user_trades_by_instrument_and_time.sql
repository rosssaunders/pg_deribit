create or replace function deribit.test_private_get_user_trades_by_instrument_and_time()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_user_trades_by_instrument_and_time_response_result;
    
	_instrument_name text;
	_start_timestamp bigint;
	_end_timestamp bigint;
	_count bigint = null;
	_sorting deribit.private_get_user_trades_by_instrument_and_time_request_sorting = null;

begin
    _expected := deribit.private_get_user_trades_by_instrument_and_time(
		instrument_name := _instrument_name,
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

