drop type if exists deribit.private_get_email_language_response cascade;
create type deribit.private_get_email_language_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_get_email_language_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_email_language_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_email_language_response.result is 'The abbreviation of the language';

