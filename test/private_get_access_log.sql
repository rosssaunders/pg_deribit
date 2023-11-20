create or replace function deribit.test_private_get_access_log()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_access_log_response_result;
    
	_"offset" bigint = null;
	_count bigint = null;

begin
    _expected := deribit.private_get_access_log(
		"offset" := _"offset",
		count := _count
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

