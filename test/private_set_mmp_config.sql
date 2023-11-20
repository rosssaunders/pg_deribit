create or replace function deribit.test_private_set_mmp_config()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_set_mmp_config_response_result;
    
	_index_name deribit.private_set_mmp_config_request_index_name;
	_"interval" bigint;
	_frozen_time bigint;
	_quantity_limit float = null;
	_delta_limit float = null;

begin
    _expected := deribit.private_set_mmp_config(
		index_name := _index_name,
		"interval" := _"interval",
		frozen_time := _frozen_time,
		quantity_limit := _quantity_limit,
		delta_limit := _delta_limit
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

