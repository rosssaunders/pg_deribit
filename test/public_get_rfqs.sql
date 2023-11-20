create or replace function deribit.test_public_get_rfqs()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_rfqs_response_result;
    
	_currency deribit.public_get_rfqs_request_currency;
	_kind deribit.public_get_rfqs_request_kind = null;

begin
    _expected := deribit.public_get_rfqs(
		currency := _currency,
		kind := _kind
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

