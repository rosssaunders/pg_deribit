drop function if exists deribit.private_cancel_withdrawal;

create or replace function deribit.private_cancel_withdrawal(
	currency deribit.private_cancel_withdrawal_request_currency,
	id float
)
returns deribit.private_cancel_withdrawal_response_result
language plpgsql
as $$
declare
	_request deribit.private_cancel_withdrawal_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		id
    )::deribit.private_cancel_withdrawal_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_withdrawal'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_cancel_withdrawal_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_withdrawal is 'Cancels withdrawal request';

