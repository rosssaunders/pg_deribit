drop function if exists deribit.private_set_email_for_subaccount;

create or replace function deribit.private_set_email_for_subaccount(
	sid bigint,
	email text
)
returns text
language sql
as $$
    
    with request as (
        select row(
			sid,
			email
        )::deribit.private_set_email_for_subaccount_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/set_email_for_subaccount'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_set_email_for_subaccount_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_set_email_for_subaccount is 'Assign an email address to a subaccount. User will receive an email with confirmation link.';

