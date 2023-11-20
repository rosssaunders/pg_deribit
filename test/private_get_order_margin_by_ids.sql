create or replace function deribit.test_private_get_order_margin_by_ids()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_get_order_margin_by_ids_response_result;
    
	_ids text[];

begin
    _expected := deribit.private_get_order_margin_by_ids(
		ids := _ids
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

