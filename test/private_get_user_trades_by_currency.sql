create or replace function deribit.test_private_get_user_trades_by_currency()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_user_trades_by_currency_response_result;
    
	_currency deribit.private_get_user_trades_by_currency_request_currency;
	_kind deribit.private_get_user_trades_by_currency_request_kind = null;
	_start_id text = null;
	_end_id text = null;
	_count bigint = null;
	_start_timestamp bigint = null;
	_end_timestamp bigint = null;
	_sorting deribit.private_get_user_trades_by_currency_request_sorting = null;
	_subaccount_id bigint = null;

begin
    _expected := deribit.private_get_user_trades_by_currency(
		currency := _currency,
		kind := _kind,
		start_id := _start_id,
		end_id := _end_id,
		count := _count,
		start_timestamp := _start_timestamp,
		end_timestamp := _end_timestamp,
		sorting := _sorting,
		subaccount_id := _subaccount_id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

