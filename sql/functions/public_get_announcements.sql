drop function if exists deribit.public_get_announcements;
create or replace function deribit.public_get_announcements(
	start_timestamp bigint default null,
	count bigint default null
)
returns setof deribit.public_get_announcements_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_announcements_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_announcements');
    
_request := row(
		start_timestamp,
		count
    )::deribit.public_get_announcements_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_announcements', _request);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_announcements_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_announcements is 'Retrieves announcements. Default "start_timestamp" parameter value is current timestamp, "count" parameter value must be between 1 and 50, default is 5.';

