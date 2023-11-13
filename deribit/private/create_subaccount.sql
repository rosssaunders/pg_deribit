insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/create_subaccount', now(), 0, '0 secs'::interval);

create type deribit.private_create_subaccount_response_eth as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	receive_notifications boolean,
	security_keys_enabled boolean,
	system_name text,
	type text,
	username text
);
comment on column deribit.private_create_subaccount_response_eth.receive_notifications is 'When true - receive all notification emails on the main email';
comment on column deribit.private_create_subaccount_response_eth.security_keys_enabled is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_create_subaccount_response_eth.system_name is 'System generated user nickname';
comment on column deribit.private_create_subaccount_response_eth.type is 'Account type';
comment on column deribit.private_create_subaccount_response_eth.username is 'Account name (given by user)';

create type deribit.private_create_subaccount_response_btc as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	eth deribit.private_create_subaccount_response_eth
);


create type deribit.private_create_subaccount_response_portfolio as (
	btc deribit.private_create_subaccount_response_btc
);


create type deribit.private_create_subaccount_response_result as (
	email text,
	id bigint,
	is_password boolean,
	login_enabled boolean,
	portfolio deribit.private_create_subaccount_response_portfolio
);
comment on column deribit.private_create_subaccount_response_result.email is 'User email';
comment on column deribit.private_create_subaccount_response_result.id is 'Subaccount identifier';
comment on column deribit.private_create_subaccount_response_result.is_password is 'true when password for the subaccount has been configured';
comment on column deribit.private_create_subaccount_response_result.login_enabled is 'Informs whether login to the subaccount is enabled';

create type deribit.private_create_subaccount_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_create_subaccount_response_result
);
comment on column deribit.private_create_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_create_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_create_subaccount()
returns deribit.private_create_subaccount_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= deribit.internal_jsonrpc_request('/private/create_subaccount');

    return (jsonb_populate_record(
        null::deribit.private_create_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_create_subaccount is 'Create a new subaccount';

