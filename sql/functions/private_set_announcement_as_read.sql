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

