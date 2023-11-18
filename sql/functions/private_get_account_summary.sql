create or replace function deribit.private_get_account_summary(
	currency deribit.private_get_account_summary_request_currency,
	subaccount_id bigint default null,
	extended boolean default null
)
returns deribit.private_get_account_summary_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_account_summary_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		subaccount_id,
		extended
    )::deribit.private_get_account_summary_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_account_summary', _request);

    perform deribit.matching_engine_request_log_call('/private/get_account_summary');

    return (jsonb_populate_record(
        null::deribit.private_get_account_summary_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_account_summary is 'Retrieves user account summary. To read subaccount summary use subaccount_id parameter.';

