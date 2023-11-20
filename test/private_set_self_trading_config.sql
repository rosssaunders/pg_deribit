create or replace function deribit.test_private_set_self_trading_config()
returns setof text
language plpgsql
as $$
declare
    _expected text;
    
	_mode deribit.private_set_self_trading_config_request_mode;
	_extended_to_subaccounts boolean;

begin
    _expected := deribit.private_set_self_trading_config(
		mode := _mode,
		extended_to_subaccounts := _extended_to_subaccounts
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

