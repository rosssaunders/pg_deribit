create or replace function deribit.test_private_submit_transfer_to_user()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_submit_transfer_to_user_response_result;
    
	_currency deribit.private_submit_transfer_to_user_request_currency;
	_amount float;
	_destination text;

begin
    _expected := deribit.private_submit_transfer_to_user(
		currency := _currency,
		amount := _amount,
		destination := _destination
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

