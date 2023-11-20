create or replace function deribit.test_private_create_subaccount()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_create_subaccount_response_result;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

