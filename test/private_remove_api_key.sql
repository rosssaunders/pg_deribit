create or replace function deribit.test_private_remove_api_key()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_id bigint;

begin
    _expected := deribit.private_remove_api_key(
		id := _id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

