create or replace function deribit.test_private_get_positions()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_positions_response_result;
    
	_currency deribit.private_get_positions_request_currency;
	_kind deribit.private_get_positions_request_kind = null;
	_subaccount_id bigint = null;

begin
    _expected := deribit.private_get_positions(
		currency := _currency,
		kind := _kind,
		subaccount_id := _subaccount_id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

