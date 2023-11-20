create or replace function deribit.test_private_get_account_summary()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_account_summary_response_result;
    
	_currency deribit.private_get_account_summary_request_currency;
	_subaccount_id bigint = null;
	_extended boolean = null;

begin
    _expected := deribit.private_get_account_summary(
		currency := _currency,
		subaccount_id := _subaccount_id,
		extended := _extended
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

