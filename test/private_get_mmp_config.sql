create or replace function deribit.test_private_get_mmp_config()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_mmp_config_response_result;
    
	_index_name deribit.private_get_mmp_config_request_index_name = null;

begin
    _expected := deribit.private_get_mmp_config(
		index_name := _index_name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

