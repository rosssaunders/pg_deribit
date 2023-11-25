drop function if exists deribit.private_cancel;

create or replace function deribit.private_cancel(
	order_id text
)
returns deribit.private_cancel_response_result
language plpgsql
as $$
declare
	_request deribit.private_cancel_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		order_id
    )::deribit.private_cancel_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel'::deribit.endpoint, _request, 'deribit.matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_cancel_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel is 'Cancel an order, specified by order id';

