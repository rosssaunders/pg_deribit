create or replace function deribit.test_public_get_supported_index_names()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_type deribit.public_get_supported_index_names_request_type = null;

begin
    _expected := deribit.public_get_supported_index_names(
		type := _type
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

