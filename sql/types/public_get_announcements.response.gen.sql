/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
drop type if exists deribit.public_get_announcements_response_result cascade;

create type deribit.public_get_announcements_response_result as (
    body text,
    confirmation boolean,
    id double precision,
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

drop type if exists deribit.public_get_announcements_response cascade;

create type deribit.public_get_announcements_response as (
    id bigint,
    jsonrpc text,
    result deribit.public_get_announcements_response_result[]
);

comment on column deribit.public_get_announcements_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_announcements_response.jsonrpc is 'The JSON-RPC version (2.0)';

