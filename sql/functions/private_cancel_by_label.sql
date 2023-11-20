drop function if exists deribit.private_cancel_by_label;
create or replace function deribit.private_cancel_by_label(
	label text,
	currency deribit.private_cancel_by_label_request_currency default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_by_label_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/cancel_by_label');
    
_request := row(
		label,
		currency
    )::deribit.private_cancel_by_label_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_by_label', _request);

    return (jsonb_populate_record(
        null::deribit.private_cancel_by_label_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_by_label is 'Cancels orders by label. All user''s orders (trigger orders too), with given label are canceled in all currencies or in one given currency (in this case currency queue is used) ';

