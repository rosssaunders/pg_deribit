insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/set_announcement_as_read', null, 0, '0 secs'::interval);

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

create or replace function deribit.private_set_announcement_as_read(
	announcement_id float
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_set_announcement_as_read_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		announcement_id
    )::deribit.private_set_announcement_as_read_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/set_announcement_as_read', _request);

    return (jsonb_populate_record(
        null::deribit.private_set_announcement_as_read_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_set_announcement_as_read is 'Marks an announcement as read, so it will not be shown in get_new_announcements.';

