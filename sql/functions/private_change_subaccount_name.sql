drop function if exists deribit.private_change_subaccount_name;

create or replace function deribit.private_change_subaccount_name(
	sid bigint,
	name text
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_change_subaccount_name_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		sid,
		name
    )::deribit.private_change_subaccount_name_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/change_subaccount_name'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_change_subaccount_name_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_change_subaccount_name is 'Change the user name for a subaccount';

