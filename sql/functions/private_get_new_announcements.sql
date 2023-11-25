drop function if exists deribit.private_get_new_announcements;

create or replace function deribit.private_get_new_announcements()
returns setof deribit.private_get_new_announcements_response_result
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_new_announcements'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_new_announcements_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).body::text,
		(b).confirmation::boolean,
		(b).id::double precision,
		(b).important::boolean,
		(b).publication_timestamp::bigint,
		(b).title::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_new_announcements is 'Retrieves announcements that have not been marked read by the user.';

