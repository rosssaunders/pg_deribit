create or replace function deribit.test_private_toggle_notifications_from_subaccount()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_sid bigint;
	_state boolean;

begin
    _expected := deribit.private_toggle_notifications_from_subaccount(
		sid := _sid,
		state := _state
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

