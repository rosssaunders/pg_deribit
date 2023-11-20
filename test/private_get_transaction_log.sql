create or replace function deribit.test_private_get_transaction_log()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_transaction_log_response_result;
    
	_currency deribit.private_get_transaction_log_request_currency;
	_start_timestamp bigint;
	_end_timestamp bigint;
	_query text = null;
	_count bigint = null;
	_continuation bigint = null;

begin
    _expected := deribit.private_get_transaction_log(
		currency := _currency,
		start_timestamp := _start_timestamp,
		end_timestamp := _end_timestamp,
		query := _query,
		count := _count,
		continuation := _continuation
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

