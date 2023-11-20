create or replace function deribit.test_private_create_api_key()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_create_api_key_response_result;
    
	_max_scope text;
	_name text = null;
	_public_key text = null;
	_enabled_features text[] = null;

begin
    _expected := deribit.private_create_api_key(
		max_scope := _max_scope,
		name := _name,
		public_key := _public_key,
		enabled_features := _enabled_features
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

