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

