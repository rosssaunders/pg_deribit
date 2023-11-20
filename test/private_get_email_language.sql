create or replace function deribit.test_private_get_email_language()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

