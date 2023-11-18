create type deribit.private_remove_api_key_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_remove_api_key_response.id is 'The id that was sent in the request';
comment on column deribit.private_remove_api_key_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_remove_api_key_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_remove_api_key_request as (
	id bigint
);
comment on column deribit.private_remove_api_key_request.id is '(Required) Id of key';

