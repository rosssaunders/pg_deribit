create or replace function deribit.test_public_get_funding_chart_data()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_funding_chart_data_response_result;
    
	_instrument_name text;
	_length deribit.public_get_funding_chart_data_request_length;

begin
    _expected := deribit.public_get_funding_chart_data(
		instrument_name := _instrument_name,
		length := _length
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

