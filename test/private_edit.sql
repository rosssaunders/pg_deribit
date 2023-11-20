create or replace function deribit.test_private_edit()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_edit_response_result;
    
	_order_id text;
	_amount float;
	_price float = null;
	_post_only boolean = null;
	_reduce_only boolean = null;
	_reject_post_only boolean = null;
	_advanced deribit.private_edit_request_advanced = null;
	_trigger_price float = null;
	_trigger_offset float = null;
	_mmp boolean = null;
	_valid_until bigint = null;

begin
    _expected := deribit.private_edit(
		order_id := _order_id,
		amount := _amount,
		price := _price,
		post_only := _post_only,
		reduce_only := _reduce_only,
		reject_post_only := _reject_post_only,
		advanced := _advanced,
		trigger_price := _trigger_price,
		trigger_offset := _trigger_offset,
		mmp := _mmp,
		valid_until := _valid_until
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

