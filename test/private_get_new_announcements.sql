create or replace function deribit.test_private_get_new_announcements()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_new_announcements_response_result;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

