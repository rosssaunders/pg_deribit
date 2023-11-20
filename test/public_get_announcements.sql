create or replace function deribit.test_public_get_announcements()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_announcements_response_result;
    
	_start_timestamp bigint = null;
	_count bigint = null;

begin
    _expected := deribit.public_get_announcements(
		start_timestamp := _start_timestamp,
		count := _count
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

