create or replace function deribit.test_private_get_transfers()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_get_transfers_response_result;
    
	_currency deribit.private_get_transfers_request_currency;
	_count bigint = null;
	_"offset" bigint = null;

begin
    _expected := deribit.private_get_transfers(
		currency := _currency,
		count := _count,
		"offset" := _"offset"
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

