create or replace function deribit.test_private_submit_transfer_to_subaccount()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_submit_transfer_to_subaccount_response_result;
    
	_currency deribit.private_submit_transfer_to_subaccount_request_currency;
	_amount float;
	_destination bigint;

begin
    _expected := deribit.private_submit_transfer_to_subaccount(
		currency := _currency,
		amount := _amount,
		destination := _destination
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

