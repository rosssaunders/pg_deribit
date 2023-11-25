drop function if exists deribit.private_toggle_notifications_from_subaccount;

create or replace function deribit.private_toggle_notifications_from_subaccount(
	sid bigint,
	state boolean
)
returns text
language sql
as $$
    
    with request as (
        select row(
			sid,
			state
        )::deribit.private_toggle_notifications_from_subaccount_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/toggle_notifications_from_subaccount'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_toggle_notifications_from_subaccount_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_toggle_notifications_from_subaccount is 'Enable or disable sending of notifications for the subaccount.';

