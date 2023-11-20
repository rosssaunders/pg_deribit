create or replace function deribit.test_private_change_api_key_name()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_change_api_key_name_response_result;
    
	_id bigint;
	_name text;

begin
    _expected := deribit.private_change_api_key_name(
		id := _id,
		name := _name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

