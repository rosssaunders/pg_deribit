drop type if exists deribit.private_set_email_for_subaccount_response cascade;
create type deribit.private_set_email_for_subaccount_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_email_for_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_email_for_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_for_subaccount_response.result is 'Result of method execution. ok in case of success';

drop type if exists deribit.private_set_email_for_subaccount_request cascade;
create type deribit.private_set_email_for_subaccount_request as (
	sid bigint,
	email text
);
comment on column deribit.private_set_email_for_subaccount_request.sid is '(Required) The user id for the subaccount';
comment on column deribit.private_set_email_for_subaccount_request.email is '(Required) The email address for the subaccount';

