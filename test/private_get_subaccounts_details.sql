create or replace function deribit.test_private_get_subaccounts_details()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_subaccounts_details_response_result;
    
	_currency deribit.private_get_subaccounts_details_request_currency;
	_with_open_orders boolean = null;

begin
    _expected := deribit.private_get_subaccounts_details(
		currency := _currency,
		with_open_orders := _with_open_orders
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

