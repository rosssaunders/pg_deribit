create or replace function deribit.test_private_reset_mmp()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_index_name deribit.private_reset_mmp_request_index_name;

begin
    _expected := deribit.private_reset_mmp(
		index_name := _index_name
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

