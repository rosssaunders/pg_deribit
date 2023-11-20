create or replace function deribit.test_private_get_settlement_history_by_currency()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_settlement_history_by_currency_response_result;
    
	_currency deribit.private_get_settlement_history_by_currency_request_currency;
	_type deribit.private_get_settlement_history_by_currency_request_type = null;
	_count bigint = null;
	_continuation text = null;
	_search_start_timestamp bigint = null;

begin
    _expected := deribit.private_get_settlement_history_by_currency(
		currency := _currency,
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

