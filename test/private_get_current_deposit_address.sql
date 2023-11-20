create or replace function deribit.test_private_get_current_deposit_address()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_current_deposit_address_response_result;
    
	_currency deribit.private_get_current_deposit_address_request_currency;

begin
    _expected := deribit.private_get_current_deposit_address(
		currency := _currency
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

