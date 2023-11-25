drop function if exists deribit.private_reset_mmp;

create or replace function deribit.private_reset_mmp(
	index_name deribit.private_reset_mmp_request_index_name
)
returns text
language sql
as $$
    
    with request as (
        select row(
			index_name
        )::deribit.private_reset_mmp_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/reset_mmp'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_reset_mmp_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_reset_mmp is 'Reset MMP';

