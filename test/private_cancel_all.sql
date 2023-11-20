create or replace function deribit.test_private_cancel_all()
returns setof text
language plpgsql
as $$
declare
    _expected float;
    
	_detailed boolean = null;

begin
    _expected := deribit.private_cancel_all(
		detailed := _detailed
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

