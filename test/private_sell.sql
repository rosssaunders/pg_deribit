create or replace function deribit.test_private_sell()
returns setof text
language plpgsql
as $$
declare
    _expected deribit.private_sell_response_result;
    
	_instrument_name text;
	_amount float;
	_type deribit.private_sell_request_type = null;
	_label text = null;
	_price float = null;
	_time_in_force deribit.private_sell_request_time_in_force = null;
	_max_show float = null;
	_post_only boolean = null;
	_reject_post_only boolean = null;
	_reduce_only boolean = null;
	_trigger_price float = null;
	_trigger_offset float = null;
	_trigger deribit.private_sell_request_trigger = null;
	_advanced deribit.private_sell_request_advanced = null;
	_mmp boolean = null;
	_valid_until bigint = null;

begin
    _expected := deribit.private_sell(
		instrument_name := _instrument_name,
		amount := _amount,
		type := _type,
		label := _label,
		price := _price,
		time_in_force := _time_in_force,
		max_show := _max_show,
		post_only := _post_only,
		reject_post_only := _reject_post_only,
		reduce_only := _reduce_only,
		trigger_price := _trigger_price,
		trigger_offset := _trigger_offset,
		trigger := _trigger,
		advanced := _advanced,
		mmp := _mmp,
		valid_until := _valid_until
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

