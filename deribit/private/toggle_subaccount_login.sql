create type deribit.private_toggle_subaccount_login_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_toggle_subaccount_login_response.id is 'The id that was sent in the request';
comment on column deribit.private_toggle_subaccount_login_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_toggle_subaccount_login_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_toggle_subaccount_login_request_state as enum ('enable', 'disable');

create type deribit.private_toggle_subaccount_login_request as (
	sid bigint,
	state deribit.private_toggle_subaccount_login_request_state
);
comment on column deribit.private_toggle_subaccount_login_request.sid is '(Required) The user id for the subaccount';
comment on column deribit.private_toggle_subaccount_login_request.state is '(Required) enable or disable login.';

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
    _request := row(
		sid,
		state
    )::deribit.private_toggle_subaccount_login_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/toggle_subaccount_login', _request));

    return (jsonb_populate_record(
        null::deribit.private_toggle_subaccount_login_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_toggle_subaccount_login is 'Enable or disable login for a subaccount. If login is disabled and a session for the subaccount exists, this session will be terminated.';

