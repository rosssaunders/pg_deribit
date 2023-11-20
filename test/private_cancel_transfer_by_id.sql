create or replace function deribit.test_private_cancel_transfer_by_id()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_cancel_transfer_by_id_response_result;
    
	_currency deribit.private_cancel_transfer_by_id_request_currency;
	_id bigint;

begin
    _expected := deribit.private_cancel_transfer_by_id(
		currency := _currency,
		id := _id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

