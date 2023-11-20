drop function if exists deribit.private_get_trigger_order_history;
create or replace function deribit.private_get_trigger_order_history(
	currency deribit.private_get_trigger_order_history_request_currency,
	instrument_name text default null,
	count bigint default null,
	continuation text default null
)
returns deribit.private_get_trigger_order_history_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_trigger_order_history_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_trigger_order_history');
    
_request := row(
		currency,
		instrument_name,
		count,
		continuation
    )::deribit.private_get_trigger_order_history_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_trigger_order_history', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_trigger_order_history_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_trigger_order_history is 'Retrieves detailed log of the user''s trigger orders.';

