create or replace function deribit.test_private_remove_subaccount()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_subaccount_id bigint;

begin
    _expected := deribit.private_remove_subaccount(
		subaccount_id := _subaccount_id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

