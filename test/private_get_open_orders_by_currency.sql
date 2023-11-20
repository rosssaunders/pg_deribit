create or replace function deribit.test_private_get_open_orders_by_currency()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_open_orders_by_currency_response_result;
    
	_currency deribit.private_get_open_orders_by_currency_request_currency;
	_kind deribit.private_get_open_orders_by_currency_request_kind = null;
	_type deribit.private_get_open_orders_by_currency_request_type = null;

begin
    _expected := deribit.private_get_open_orders_by_currency(
		currency := _currency,
		kind := _kind,
		type := _type
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

