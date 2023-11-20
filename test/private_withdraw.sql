create or replace function deribit.test_private_withdraw()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_withdraw_response_result;
    
	_currency deribit.private_withdraw_request_currency;
	_address text;
	_amount float;
	_priority deribit.private_withdraw_request_priority = null;

begin
    _expected := deribit.private_withdraw(
		currency := _currency,
		address := _address,
		amount := _amount,
		priority := _priority
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

