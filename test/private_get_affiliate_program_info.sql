create or replace function deribit.test_private_get_affiliate_program_info()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_affiliate_program_info_response_result;
    
begin
    
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

