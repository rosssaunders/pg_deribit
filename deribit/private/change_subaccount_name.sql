insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/change_subaccount_name', now(), 0, '0 secs'::interval);

create type deribit.private_change_subaccount_name_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_change_subaccount_name_response.id is 'The id that was sent in the request';
comment on column deribit.private_change_subaccount_name_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_change_subaccount_name_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_change_subaccount_name_request as (
	sid bigint,
	name text
);
comment on column deribit.private_change_subaccount_name_request.sid is '(Required) The user id for the subaccount';
comment on column deribit.private_change_subaccount_name_request.name is '(Required) The new user name';

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
    
    _http_response := deribit.internal_jsonrpc_request('/private/change_subaccount_name', _request);

    return (jsonb_populate_record(
        null::deribit.private_change_subaccount_name_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_change_subaccount_name is 'Change the user name for a subaccount';

