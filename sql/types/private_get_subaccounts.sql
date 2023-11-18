create type deribit.private_get_subaccounts_response_eth as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	proof_id text,
	proof_id_signature text,
	receive_notifications boolean,
	security_keys_assignments text[],
	security_keys_enabled boolean,
	system_name text,
	type text,
	username text
);
comment on column deribit.private_get_subaccounts_response_eth.proof_id is 'hashed identifier used in the Proof Of Liability for the subaccount. This identifier allows you to find your entries in the Deribit Proof-Of-Reserves files. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_eth.proof_id_signature is 'signature used as a base string for proof_id hash. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_eth.receive_notifications is 'When true - receive all notification emails on the main email';
comment on column deribit.private_get_subaccounts_response_eth.security_keys_assignments is 'Names of assignments with Security Keys assigned';
comment on column deribit.private_get_subaccounts_response_eth.security_keys_enabled is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_get_subaccounts_response_eth.system_name is 'System generated user nickname';

create type deribit.private_get_subaccounts_response_btc as (
	available_funds float,
	available_withdrawal_funds float,
	balance float,
	currency text,
	equity float,
	initial_margin float,
	maintenance_margin float,
	margin_balance float,
	eth deribit.private_get_subaccounts_response_eth
);


create type deribit.private_get_subaccounts_response_portfolio as (
	btc deribit.private_get_subaccounts_response_btc
);


create type deribit.private_get_subaccounts_response_result as (
	email text,
	id bigint,
	is_password boolean,
	login_enabled boolean,
	not_confirmed_email text,
	portfolio deribit.private_get_subaccounts_response_portfolio
);
comment on column deribit.private_get_subaccounts_response_result.email is 'User email';
comment on column deribit.private_get_subaccounts_response_result.id is 'Account/Subaccount identifier';
comment on column deribit.private_get_subaccounts_response_result.is_password is 'true when password for the subaccount has been configured';
comment on column deribit.private_get_subaccounts_response_result.login_enabled is 'Informs whether login to the subaccount is enabled';
comment on column deribit.private_get_subaccounts_response_result.not_confirmed_email is 'New email address that has not yet been confirmed. This field is only included if with_portfolio == true.';

create type deribit.private_get_subaccounts_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_subaccounts_response_result[]
);
comment on column deribit.private_get_subaccounts_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_subaccounts_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_subaccounts_request as (
	with_portfolio boolean
);
comment on column deribit.private_get_subaccounts_request.with_portfolio is 'nan';

