drop function if exists deribit.private_get_order_state_by_label;
create or replace function deribit.private_get_order_state_by_label(
	currency deribit.private_get_order_state_by_label_request_currency,
	label text default null
)
returns setof deribit.private_get_order_state_by_label_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_order_state_by_label_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_order_state_by_label');
    
_request := row(
		currency,
		label
    )::deribit.private_get_order_state_by_label_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_order_state_by_label', _request);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_order_state_by_label_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_order_state_by_label is 'Retrieve the state of recent orders with a given label.';

