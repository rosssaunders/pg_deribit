drop function if exists deribit.private_get_open_orders_by_label;

create or replace function deribit.private_get_open_orders_by_label(
	currency deribit.private_get_open_orders_by_label_request_currency,
	label text default null
)
returns setof deribit.private_get_open_orders_by_label_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_open_orders_by_label_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		label
    )::deribit.private_get_open_orders_by_label_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_open_orders_by_label'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_open_orders_by_label_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_open_orders_by_label is 'Retrieves list of user''s open orders for given currency and label.';

