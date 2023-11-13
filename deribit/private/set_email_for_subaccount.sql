insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/set_email_for_subaccount', now(), 0, '0 secs'::interval);

create type deribit.private_set_email_for_subaccount_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_email_for_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_email_for_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_for_subaccount_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_set_email_for_subaccount_request as (
	sid bigint,
	email text
);
comment on column deribit.private_set_email_for_subaccount_request.sid is '(Required) The user id for the subaccount';
comment on column deribit.private_set_email_for_subaccount_request.email is '(Required) The email address for the subaccount';

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

