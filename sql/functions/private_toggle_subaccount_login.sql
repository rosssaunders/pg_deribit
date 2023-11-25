drop function if exists deribit.private_toggle_subaccount_login;

create or replace function deribit.private_toggle_subaccount_login(
	sid bigint,
	state deribit.private_toggle_subaccount_login_request_state
)
returns text
language sql
as $$
    
    with request as (
        select row(
			sid,
			state
        )::deribit.private_toggle_subaccount_login_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/toggle_subaccount_login'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_toggle_subaccount_login_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_toggle_subaccount_login is 'Enable or disable login for a subaccount. If login is disabled and a session for the subaccount exists, this session will be terminated.';

