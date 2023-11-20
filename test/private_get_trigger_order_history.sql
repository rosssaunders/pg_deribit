create or replace function deribit.test_private_get_trigger_order_history()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_trigger_order_history_response_result;
    
	_currency deribit.private_get_trigger_order_history_request_currency;
	_instrument_name text = null;
	_count bigint = null;
	_continuation text = null;

begin
    _expected := deribit.private_get_trigger_order_history(
		currency := _currency,
		instrument_name := _instrument_name,
		count := _count,
		continuation := _continuation
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

