create or replace function deribit.test_private_cancel_by_label()
returns setof text
language plpgsql
as $$
declare
    _expected float;
    
	_label text;
	_currency deribit.private_cancel_by_label_request_currency = null;

begin
    _expected := deribit.private_cancel_by_label(
		label := _label,
		currency := _currency
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

