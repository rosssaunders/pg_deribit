create or replace function deribit.private_edit_by_label(
	label text default null,
	instrument_name text,
	amount float,
	price float default null,
	post_only boolean default null,
	reduce_only boolean default null,
	reject_post_only boolean default null,
	advanced deribit.private_edit_by_label_request_advanced default null,
	trigger_price float default null,
	mmp boolean default null,
	valid_until bigint default null
)
returns deribit.private_edit_by_label_response_result
language plpgsql
as $$
declare
	_request deribit.private_edit_by_label_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		label,
		instrument_name,
		amount,
		price,
		post_only,
		reduce_only,
		reject_post_only,
		advanced,
		trigger_price,
		mmp,
		valid_until
    )::deribit.private_edit_by_label_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/edit_by_label', _request);

    perform deribit.matching_engine_request_log_call('/private/edit_by_label');

    return (jsonb_populate_record(
        null::deribit.private_edit_by_label_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_edit_by_label is 'Change price, amount and/or other properties of an order with given label. It works only when there is one open order with this label';

