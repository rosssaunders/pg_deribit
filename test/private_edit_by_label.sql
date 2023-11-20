create or replace function deribit.test_private_edit_by_label()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_edit_by_label_response_result;
    
	_label text = null;
	_instrument_name text;
	_amount float;
	_price float = null;
	_post_only boolean = null;
	_reduce_only boolean = null;
	_reject_post_only boolean = null;
	_advanced deribit.private_edit_by_label_request_advanced = null;
	_trigger_price float = null;
	_mmp boolean = null;
	_valid_until bigint = null;

begin
    _expected := deribit.private_edit_by_label(
		label := _label,
		instrument_name := _instrument_name,
		amount := _amount,
		price := _price,
		post_only := _post_only,
		reduce_only := _reduce_only,
		reject_post_only := _reject_post_only,
		advanced := _advanced,
		trigger_price := _trigger_price,
		mmp := _mmp,
		valid_until := _valid_until
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

