create type deribit.public_get_announcements_response_result as (
	body text,
	confirmation boolean,
	id float,
	important boolean,
	publication_timestamp bigint,
	title text
);
comment on column deribit.public_get_announcements_response_result.body is 'The HTML body of the announcement';
comment on column deribit.public_get_announcements_response_result.confirmation is 'Whether the user confirmation is required for this announcement';
comment on column deribit.public_get_announcements_response_result.id is 'A unique identifier for the announcement';
comment on column deribit.public_get_announcements_response_result.important is 'Whether the announcement is marked as important';
comment on column deribit.public_get_announcements_response_result.publication_timestamp is 'The timestamp (milliseconds since the Unix epoch) of announcement publication';
comment on column deribit.public_get_announcements_response_result.title is 'The title of the announcement';

create type deribit.public_get_announcements_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_announcements_response_result[]
);
comment on column deribit.public_get_announcements_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_announcements_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_announcements_request as (
	start_timestamp bigint,
	count bigint
);
comment on column deribit.public_get_announcements_request.start_timestamp is 'The most recent timestamp to return the results for (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_announcements_request.count is 'Maximum count of returned announcements';

