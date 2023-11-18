create or replace function deribit.private_cancel_transfer_by_id(
	currency deribit.private_cancel_transfer_by_id_request_currency,
	id bigint
)
returns deribit.private_cancel_transfer_by_id_response_result
language plpgsql
as $$
declare
	_request deribit.private_cancel_transfer_by_id_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		id
    )::deribit.private_cancel_transfer_by_id_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_transfer_by_id', _request);

    perform deribit.matching_engine_request_log_call('/private/cancel_transfer_by_id');

    return (jsonb_populate_record(
        null::deribit.private_cancel_transfer_by_id_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_transfer_by_id is 'Cancel transfer';

