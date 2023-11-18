create or replace function deribit.private_get_order_state(
	order_id text
)
returns deribit.private_get_order_state_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_order_state_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		order_id
    )::deribit.private_get_order_state_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_order_state', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_order_state_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_order_state is 'Retrieve the current state of an order.';

