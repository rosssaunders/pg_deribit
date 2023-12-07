/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
drop type if exists deribit.private_get_subaccounts_response_eth cascade;

create type deribit.private_get_subaccounts_response_eth as (
    available_funds double precision,
    available_withdrawal_funds double precision,
    balance double precision,
    currency text,
    equity double precision,
    initial_margin double precision,
    maintenance_margin double precision,
    margin_balance double precision
);



drop type if exists deribit.private_get_subaccounts_response_btc cascade;

create type deribit.private_get_subaccounts_response_btc as (
    available_funds double precision,
    available_withdrawal_funds double precision,
    balance double precision,
    currency text,
    equity double precision,
    initial_margin double precision,
    maintenance_margin double precision,
    margin_balance double precision
);



drop type if exists deribit.private_get_subaccounts_response_portfolio cascade;

create type deribit.private_get_subaccounts_response_portfolio as (
    btc deribit.private_get_subaccounts_response_btc,
    eth deribit.private_get_subaccounts_response_eth,
    proof_id text,
    proof_id_signature text,
    receive_notifications boolean,
    security_keys_assignments text[],
    security_keys_enabled boolean,
    system_name text,
    type text,
    username text
);

comment on column deribit.private_get_subaccounts_response_portfolio.proof_id is 'hashed identifier used in the Proof Of Liability for the subaccount. This identifier allows you to find your entries in the Deribit Proof-Of-Reserves files. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_portfolio.proof_id_signature is 'signature used as a base string for proof_id hash. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_portfolio.receive_notifications is 'When true - receive all notification emails on the main email';
comment on column deribit.private_get_subaccounts_response_portfolio.security_keys_assignments is 'Names of assignments with Security Keys assigned';
comment on column deribit.private_get_subaccounts_response_portfolio.security_keys_enabled is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_get_subaccounts_response_portfolio.system_name is 'System generated user nickname';

drop type if exists deribit.private_get_subaccounts_response_result cascade;

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

drop type if exists deribit.private_get_subaccounts_response cascade;

create type deribit.private_get_subaccounts_response as (
    id bigint,
    jsonrpc text,
    result deribit.private_get_subaccounts_response_result[]
);

comment on column deribit.private_get_subaccounts_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_subaccounts_response.jsonrpc is 'The JSON-RPC version (2.0)';

