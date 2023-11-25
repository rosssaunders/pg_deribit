drop function if exists deribit.private_change_subaccount_name;

create or replace function deribit.private_change_subaccount_name(
	sid bigint,
	name text
)
returns text
language sql
as $$
    
    with request as (
        select row(
			sid,
			name
        )::deribit.private_change_subaccount_name_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/change_subaccount_name'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_change_subaccount_name_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_change_subaccount_name is 'Change the user name for a subaccount';

