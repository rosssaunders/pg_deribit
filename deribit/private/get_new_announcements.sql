insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_new_announcements', now(), 0, '0 secs'::interval);

create type deribit.private_get_new_announcements_response_result as (
	body text,
	confirmation boolean,
	id float,
	important boolean,
	publication_timestamp bigint,
	title text
);
comment on column deribit.private_get_new_announcements_response_result.body is 'The HTML body of the announcement';
comment on column deribit.private_get_new_announcements_response_result.confirmation is 'Whether the user confirmation is required for this announcement';
comment on column deribit.private_get_new_announcements_response_result.id is 'A unique identifier for the announcement';
comment on column deribit.private_get_new_announcements_response_result.important is 'Whether the announcement is marked as important';
comment on column deribit.private_get_new_announcements_response_result.publication_timestamp is 'The timestamp (milliseconds since the Unix epoch) of announcement publication';
comment on column deribit.private_get_new_announcements_response_result.title is 'The title of the announcement';

create type deribit.private_get_new_announcements_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_new_announcements_response_result[]
);
comment on column deribit.private_get_new_announcements_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_new_announcements_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_new_announcements()
returns setof deribit.private_get_new_announcements_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= deribit.internal_jsonrpc_request('/private/get_new_announcements');

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.private_get_new_announcements_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.private_get_new_announcements is 'Retrieves announcements that have not been marked read by the user.';

