create or replace function deribit.test_public_get_last_trades_by_currency()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_last_trades_by_currency_response_result;
    
	_currency deribit.public_get_last_trades_by_currency_request_currency;
	_kind deribit.public_get_last_trades_by_currency_request_kind = null;
	_start_id text = null;
	_end_id text = null;
	_start_timestamp bigint = null;
	_end_timestamp bigint = null;
	_count bigint = null;
	_sorting deribit.public_get_last_trades_by_currency_request_sorting = null;

begin
    _expected := deribit.public_get_last_trades_by_currency(
		currency := _currency,
		kind := _kind,
		start_id := _start_id,
		end_id := _end_id,
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

