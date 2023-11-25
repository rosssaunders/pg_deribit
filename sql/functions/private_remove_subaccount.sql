drop function if exists deribit.private_remove_subaccount;

create or replace function deribit.private_remove_subaccount(
	subaccount_id bigint
)
returns text
language sql
as $$
    
    with request as (
        select row(
			subaccount_id
        )::deribit.private_remove_subaccount_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/remove_subaccount'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_remove_subaccount_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_remove_subaccount is 'Remove empty subaccount.';

