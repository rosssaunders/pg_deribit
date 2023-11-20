create or replace function deribit.test_private_toggle_portfolio_margining()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_toggle_portfolio_margining_response_result;
    
	_user_id bigint = null;
	_enabled boolean;
	_dry_run boolean = null;

begin
    _expected := deribit.private_toggle_portfolio_margining(
		user_id := _user_id,
		enabled := _enabled,
		dry_run := _dry_run
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

