create or replace function deribit.test_public_get_instruments()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_instruments_response_result;
    
	_currency deribit.public_get_instruments_request_currency;
	_kind deribit.public_get_instruments_request_kind = null;
	_expired boolean = null;

begin
    _expected := deribit.public_get_instruments(
		currency := _currency,
		kind := _kind,
		expired := _expired
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

