drop function if exists deribit.private_list_api_keys;

create or replace function deribit.private_list_api_keys()
returns setof deribit.private_list_api_keys_response_result
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/list_api_keys'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_list_api_keys_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).client_id::text,
		(b).client_secret::text,
		(b)."default"::boolean,
		(b).enabled::boolean,
		(b).enabled_features::text[],
		(b).id::bigint,
		(b).max_scope::text,
		(b).name::text,
		(b).public_key::text,
		(b).timestamp::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_list_api_keys is 'Retrieves list of api keys. Important notes.';

