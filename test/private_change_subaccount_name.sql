create or replace function deribit.test_private_change_subaccount_name()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_sid bigint;
	_name text;

begin
    _expected := deribit.private_change_subaccount_name(
		sid := _sid,
		name := _name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

