drop function if exists deribit.private_get_subaccounts;

create or replace function deribit.private_get_subaccounts(
	with_portfolio boolean default null
)
returns setof deribit.private_get_subaccounts_response_result
language sql
as $$
    
    with request as (
        select row(
			with_portfolio
        )::deribit.private_get_subaccounts_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_subaccounts'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_subaccounts_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).email::text,
		(b).id::bigint,
		(b).is_password::boolean,
		(b).login_enabled::boolean,
		(b).not_confirmed_email::text,
		(b).portfolio::deribit.private_get_subaccounts_response_portfolio
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_subaccounts is 'Get information about subaccounts';

