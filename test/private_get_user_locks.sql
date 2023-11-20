create or replace function deribit.test_private_get_user_locks()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_user_locks_response_result;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

