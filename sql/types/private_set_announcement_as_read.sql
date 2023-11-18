create type deribit.private_set_announcement_as_read_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_announcement_as_read_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_announcement_as_read_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_announcement_as_read_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_set_announcement_as_read_request as (
	announcement_id float
);
comment on column deribit.private_set_announcement_as_read_request.announcement_id is '(Required) the ID of the announcement';

