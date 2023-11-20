create or replace function deribit.test_private_enable_api_key()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_enable_api_key_response_result;
    
	_id bigint;

begin
    _expected := deribit.private_enable_api_key(
		id := _id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

