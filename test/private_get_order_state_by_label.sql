create or replace function deribit.test_private_get_order_state_by_label()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_order_state_by_label_response_result;
    
	_currency deribit.private_get_order_state_by_label_request_currency;
	_label text = null;

begin
    _expected := deribit.private_get_order_state_by_label(
		currency := _currency,
		label := _label
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

