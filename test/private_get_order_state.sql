create or replace function deribit.test_private_get_order_state()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_order_state_response_result;
    
	_order_id text;

begin
    _expected := deribit.private_get_order_state(
		order_id := _order_id
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

