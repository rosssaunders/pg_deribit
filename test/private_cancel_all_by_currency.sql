create or replace function deribit.test_private_cancel_all_by_currency()
returns setof text
language plpgsql
as $$
declare
    _expected float;
    
	_currency deribit.private_cancel_all_by_currency_request_currency;
	_kind deribit.private_cancel_all_by_currency_request_kind = null;
	_type deribit.private_cancel_all_by_currency_request_type = null;
	_detailed boolean = null;

begin
    _expected := deribit.private_cancel_all_by_currency(
		currency := _currency,
		kind := _kind,
		type := _type,
		detailed := _detailed
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

