create or replace function deribit.test_private_set_email_for_subaccount()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_sid bigint;
	_email text;

begin
    _expected := deribit.private_set_email_for_subaccount(
		sid := _sid,
		email := _email
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

