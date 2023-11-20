create or replace function deribit.test_private_set_email_language()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_language text;

begin
    _expected := deribit.private_set_email_language(
		language := _language
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

