create or replace function deribit.test_public_get_volatility_index_data()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_volatility_index_data_response_result;
    
	_currency deribit.public_get_volatility_index_data_request_currency;
	_start_timestamp bigint;
	_end_timestamp bigint;
	_resolution deribit.public_get_volatility_index_data_request_resolution;

begin
    _expected := deribit.public_get_volatility_index_data(
		currency := _currency,
		start_timestamp := _start_timestamp,
		end_timestamp := _end_timestamp,
		resolution := _resolution
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

