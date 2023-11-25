drop function if exists deribit.private_get_new_announcements;

create or replace function deribit.private_get_new_announcements()
returns setof deribit.private_get_new_announcements_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
    
begin

    _http_response := deribit.internal_jsonrpc_request('/private/get_new_announcements'::deribit.endpoint, null::text, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_new_announcements_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_new_announcements is 'Retrieves announcements that have not been marked read by the user.';

