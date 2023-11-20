create or replace function deribit.test_public_get_trade_volumes()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.public_get_trade_volumes_response_result;
    
	_extended boolean = null;

begin
    _expected := deribit.public_get_trade_volumes(
		extended := _extended
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

