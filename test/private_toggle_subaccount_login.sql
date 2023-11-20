create or replace function deribit.test_private_toggle_subaccount_login()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_sid bigint;
	_state deribit.private_toggle_subaccount_login_request_state;

begin
    _expected := deribit.private_toggle_subaccount_login(
		sid := _sid,
		state := _state
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

