drop function if exists deribit.private_toggle_subaccount_login;
create or replace function deribit.private_toggle_subaccount_login(
	sid bigint,
	state deribit.private_toggle_subaccount_login_request_state
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_toggle_subaccount_login_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/toggle_subaccount_login');
    
_request := row(
		sid,
		state
    )::deribit.private_toggle_subaccount_login_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/toggle_subaccount_login', _request);

    return (jsonb_populate_record(
        null::deribit.private_toggle_subaccount_login_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_toggle_subaccount_login is 'Enable or disable login for a subaccount. If login is disabled and a session for the subaccount exists, this session will be terminated.';

