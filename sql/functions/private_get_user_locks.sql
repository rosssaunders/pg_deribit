drop function if exists deribit.private_get_user_locks;

create or replace function deribit.private_get_user_locks()
returns setof deribit.private_get_user_locks_response_result
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_user_locks'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_user_locks_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).currency::text,
		(b).enabled::boolean,
		(b).message::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_user_locks is 'Retrieves information about locks on user account';

