create or replace function deribit.test_public_get_index_price_names()
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

