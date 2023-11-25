drop function if exists deribit.private_set_announcement_as_read;

create or replace function deribit.private_set_announcement_as_read(
	announcement_id double precision
)
returns text
language sql
as $$
    
    with request as (
        select row(
			announcement_id
        )::deribit.private_set_announcement_as_read_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/set_announcement_as_read'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_set_announcement_as_read_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_set_announcement_as_read is 'Marks an announcement as read, so it will not be shown in get_new_announcements.';

