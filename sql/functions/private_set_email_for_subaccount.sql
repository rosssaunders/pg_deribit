drop function if exists deribit.private_set_email_for_subaccount;
create or replace function deribit.private_set_email_for_subaccount(
	sid bigint,
	email text
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_set_email_for_subaccount_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/set_email_for_subaccount');
    
_request := row(
		sid,
		email
    )::deribit.private_set_email_for_subaccount_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/set_email_for_subaccount', _request);

    return (jsonb_populate_record(
        null::deribit.private_set_email_for_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_set_email_for_subaccount is 'Assign an email address to a subaccount. User will receive an email with confirmation link.';

