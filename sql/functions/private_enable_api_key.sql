drop function if exists deribit.private_enable_api_key;

create or replace function deribit.private_enable_api_key(
	id bigint
)
returns deribit.private_enable_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
			id
        )::deribit.private_enable_api_key_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/enable_api_key'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_enable_api_key_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_enable_api_key is 'Enables api key with given id. Important notes.';

