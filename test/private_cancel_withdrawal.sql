create or replace function deribit.test_private_cancel_withdrawal()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_cancel_withdrawal_response_result;
    
	_currency deribit.private_cancel_withdrawal_request_currency;
	_id float;

begin
    _expected := deribit.private_cancel_withdrawal(
		currency := _currency,
		id := _id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

