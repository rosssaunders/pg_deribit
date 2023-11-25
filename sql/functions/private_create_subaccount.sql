drop function if exists deribit.private_create_subaccount;

create or replace function deribit.private_create_subaccount()
returns deribit.private_create_subaccount_response_result
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/create_subaccount'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	select (jsonb_populate_record(
        null::deribit.private_create_subaccount_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_create_subaccount is 'Create a new subaccount';

