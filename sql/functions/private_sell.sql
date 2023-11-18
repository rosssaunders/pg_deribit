create or replace function deribit.private_sell(
	instrument_name text,
	amount float,
	type deribit.private_sell_request_type default null,
	label text default null,
	price float default null,
	time_in_force deribit.private_sell_request_time_in_force default null,
	max_show float default null,
	post_only boolean default null,
	reject_post_only boolean default null,
	reduce_only boolean default null,
	trigger_price float default null,
	trigger_offset float default null,
	trigger deribit.private_sell_request_trigger default null,
	advanced deribit.private_sell_request_advanced default null,
	mmp boolean default null,
	valid_until bigint default null
)
returns deribit.private_sell_response_result
language plpgsql
as $$
declare
	_request deribit.private_sell_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		amount,
		type,
		label,
		price,
		time_in_force,
		max_show,
		post_only,
		reject_post_only,
		reduce_only,
		trigger_price,
		trigger_offset,
		trigger,
		advanced,
		mmp,
		valid_until
    )::deribit.private_sell_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/sell', _request);

    return (jsonb_populate_record(
        null::deribit.private_sell_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_sell is 'Places a sell order for an instrument.';

