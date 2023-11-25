drop function if exists deribit.private_toggle_notifications_from_subaccount;

create or replace function deribit.private_toggle_notifications_from_subaccount(
	sid bigint,
	state boolean
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_toggle_notifications_from_subaccount_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		sid,
		state
    )::deribit.private_toggle_notifications_from_subaccount_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/toggle_notifications_from_subaccount'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_toggle_notifications_from_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_toggle_notifications_from_subaccount is 'Enable or disable sending of notifications for the subaccount.';

