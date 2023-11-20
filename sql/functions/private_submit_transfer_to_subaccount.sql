drop function if exists deribit.private_submit_transfer_to_subaccount;
create or replace function deribit.private_submit_transfer_to_subaccount(
	currency deribit.private_submit_transfer_to_subaccount_request_currency,
	amount float,
	destination bigint
)
returns deribit.private_submit_transfer_to_subaccount_response_result
language plpgsql
as $$
declare
	_request deribit.private_submit_transfer_to_subaccount_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/submit_transfer_to_subaccount');
    
_request := row(
		currency,
		amount,
		destination
    )::deribit.private_submit_transfer_to_subaccount_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/submit_transfer_to_subaccount', _request);

    return (jsonb_populate_record(
        null::deribit.private_submit_transfer_to_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_submit_transfer_to_subaccount is 'Transfer funds to subaccount.';

