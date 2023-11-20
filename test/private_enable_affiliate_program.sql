create or replace function deribit.test_private_enable_affiliate_program()
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

