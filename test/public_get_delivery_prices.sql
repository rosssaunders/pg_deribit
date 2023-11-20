create or replace function deribit.test_public_get_delivery_prices()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.public_get_delivery_prices_response_result;
    
	_index_name deribit.public_get_delivery_prices_request_index_name;
	_"offset" bigint = null;
	_count bigint = null;

begin
    _expected := deribit.public_get_delivery_prices(
		index_name := _index_name,
		"offset" := _"offset",
		count := _count
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

