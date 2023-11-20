drop type if exists deribit.private_remove_subaccount_response cascade;
create type deribit.private_remove_subaccount_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_remove_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_remove_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_remove_subaccount_response.result is 'Result of method execution. ok in case of success';

drop type if exists deribit.private_remove_subaccount_request cascade;
create type deribit.private_remove_subaccount_request as (
	subaccount_id bigint
);
comment on column deribit.private_remove_subaccount_request.subaccount_id is '(Required) The user id for the subaccount';

