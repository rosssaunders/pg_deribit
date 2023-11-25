drop type if exists deribit.private_toggle_subaccount_login_response cascade;
create type deribit.private_toggle_subaccount_login_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_toggle_subaccount_login_response.id is 'The id that was sent in the request';
comment on column deribit.private_toggle_subaccount_login_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_toggle_subaccount_login_response.result is 'Result of method execution. ok in case of success';

drop type if exists deribit.private_toggle_subaccount_login_request_state cascade;
create type deribit.private_toggle_subaccount_login_request_state as enum ('disable', 'enable');

drop type if exists deribit.private_toggle_subaccount_login_request cascade;
create type deribit.private_toggle_subaccount_login_request as (
	sid bigint,
	state deribit.private_toggle_subaccount_login_request_state
);
comment on column deribit.private_toggle_subaccount_login_request.sid is '(Required) The user id for the subaccount';
comment on column deribit.private_toggle_subaccount_login_request.state is '(Required) enable or disable login.';

