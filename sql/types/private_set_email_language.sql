drop type if exists deribit.private_set_email_language_response cascade;
create type deribit.private_set_email_language_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_email_language_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_email_language_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_language_response.result is 'Result of method execution. ok in case of success';

drop type if exists deribit.private_set_email_language_request cascade;
create type deribit.private_set_email_language_request as (
	language text
);
comment on column deribit.private_set_email_language_request.language is '(Required) The abbreviated language name. Valid values include "en", "ko", "zh", "ja", "ru"';

