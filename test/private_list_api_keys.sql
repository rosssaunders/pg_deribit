create or replace function deribit.test_private_list_api_keys()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_list_api_keys_response_result;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

