create or replace function deribit.test_public_get_tradingview_chart_data()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_tradingview_chart_data_response_result;
    
	_instrument_name text;
	_start_timestamp bigint;
	_end_timestamp bigint;
	_resolution deribit.public_get_tradingview_chart_data_request_resolution;

begin
    _expected := deribit.public_get_tradingview_chart_data(
		instrument_name := _instrument_name,
		start_timestamp := _start_timestamp,
		end_timestamp := _end_timestamp,
		resolution := _resolution
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

