create or replace function deribit.test_private_change_scope_in_api_key()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_change_scope_in_api_key_response_result;
    
	_max_scope text;
	_id bigint;

begin
    _expected := deribit.private_change_scope_in_api_key(
		max_scope := _max_scope,
		id := _id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

