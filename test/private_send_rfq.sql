create or replace function deribit.test_private_send_rfq()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_instrument_name text;
	_amount float = null;
	_side deribit.private_send_rfq_request_side = null;

begin
    _expected := deribit.private_send_rfq(
		instrument_name := _instrument_name,
		amount := _amount,
		side := _side
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

