drop function if exists deribit.private_edit;

create or replace function deribit.private_edit(
	order_id text,
	amount float,
	price float default null,
	post_only boolean default null,
	reduce_only boolean default null,
	reject_post_only boolean default null,
	advanced deribit.private_edit_request_advanced default null,
	trigger_price float default null,
	trigger_offset float default null,
	mmp boolean default null,
	valid_until bigint default null
)
returns deribit.private_edit_response_result
language plpgsql
as $$
declare
	_request deribit.private_edit_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		order_id,
		amount,
		price,
		post_only,
		reduce_only,
		reject_post_only,
		advanced,
		trigger_price,
		trigger_offset,
		mmp,
		valid_until
    )::deribit.private_edit_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/edit'::deribit.endpoint, _request, 'deribit.matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_edit_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_edit is 'Change price, amount and/or other properties of an order.';

