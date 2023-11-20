create or replace function deribit.test_private_get_portfolio_margins()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_portfolio_margins_response_result;
    
	_currency deribit.private_get_portfolio_margins_request_currency;
	_add_positions boolean = null;
	_simulated_positions jsonb = null;

begin
    _expected := deribit.private_get_portfolio_margins(
		currency := _currency,
		add_positions := _add_positions,
		simulated_positions := _simulated_positions
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

