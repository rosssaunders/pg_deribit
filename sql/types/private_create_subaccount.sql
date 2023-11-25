drop type if exists deribit.private_create_subaccount_response_eth cascade;
create type deribit.private_create_subaccount_response_eth as (
	available_funds double precision,
	available_withdrawal_funds double precision,
	balance double precision,
	currency text,
	equity double precision,
	initial_margin double precision,
	maintenance_margin double precision,
	margin_balance double precision,
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

drop type if exists deribit.private_create_subaccount_response_btc cascade;
create type deribit.private_create_subaccount_response_btc as (
	available_funds double precision,
	available_withdrawal_funds double precision,
	balance double precision,
	currency text,
	equity double precision,
	initial_margin double precision,
	maintenance_margin double precision,
	margin_balance double precision,
	eth deribit.private_create_subaccount_response_eth
);


drop type if exists deribit.private_create_subaccount_response_portfolio cascade;
create type deribit.private_create_subaccount_response_portfolio as (
	btc deribit.private_create_subaccount_response_btc
);


drop type if exists deribit.private_create_subaccount_response_result cascade;
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

drop type if exists deribit.private_create_subaccount_response cascade;
create type deribit.private_create_subaccount_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_create_subaccount_response_result
);
comment on column deribit.private_create_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_create_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';

