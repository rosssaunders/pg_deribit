create or replace function deribit.test_private_set_announcement_as_read()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_announcement_id float;

begin
    _expected := deribit.private_set_announcement_as_read(
		announcement_id := _announcement_id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

