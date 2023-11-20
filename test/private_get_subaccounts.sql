create or replace function deribit.test_private_get_subaccounts()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_subaccounts_response_result;
    
	_with_portfolio boolean = null;

begin
    _expected := deribit.private_get_subaccounts(
		with_portfolio := _with_portfolio
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

