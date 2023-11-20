create or replace function deribit.test_public_get_historical_volatility()
returns setof text
language plpgsql
as $$
declare
    _expected UNKNOWN - array of [timestamp, value];
    
	_currency deribit.public_get_historical_volatility_request_currency;

begin
    _expected := deribit.public_get_historical_volatility(
		currency := _currency
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

