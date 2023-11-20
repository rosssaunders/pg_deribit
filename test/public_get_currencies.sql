create or replace function deribit.test_public_get_currencies()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_currencies_response_result;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

