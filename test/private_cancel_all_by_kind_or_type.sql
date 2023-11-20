create or replace function deribit.test_private_cancel_all_by_kind_or_type()
returns setof text
language plpgsql
as $$
declare
    _expected float;
    
	_currency UNKNOWN - string or array of strings;
	_kind deribit.private_cancel_all_by_kind_or_type_request_kind = null;
	_type deribit.private_cancel_all_by_kind_or_type_request_type = null;
	_detailed boolean = null;

begin
    _expected := deribit.private_cancel_all_by_kind_or_type(
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

