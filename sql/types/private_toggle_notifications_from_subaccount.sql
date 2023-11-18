create type deribit.private_toggle_notifications_from_subaccount_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_toggle_notifications_from_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_toggle_notifications_from_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_toggle_notifications_from_subaccount_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_toggle_notifications_from_subaccount_request as (
	sid bigint,
	state boolean
);
comment on column deribit.private_toggle_notifications_from_subaccount_request.sid is '(Required) The user id for the subaccount';
comment on column deribit.private_toggle_notifications_from_subaccount_request.state is '(Required) enable (true) or disable (false) notifications';

