drop function if exists deribit.private_change_api_key_name;

create or replace function deribit.private_change_api_key_name(
	id bigint,
	name text
)
returns deribit.private_change_api_key_name_response_result
language sql
as $$
    
    with request as (
        select row(
			id,
			name
        )::deribit.private_change_api_key_name_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/change_api_key_name'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_change_api_key_name_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_change_api_key_name is 'Changes name for key with given id. Important notes.';

