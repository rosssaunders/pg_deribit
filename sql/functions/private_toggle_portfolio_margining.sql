drop function if exists deribit.private_toggle_portfolio_margining;

create or replace function deribit.private_toggle_portfolio_margining(
	enabled boolean,
	user_id bigint default null,
	dry_run boolean default null
)
returns setof deribit.private_toggle_portfolio_margining_response_result
language sql
as $$
    
    with request as (
        select row(
			user_id,
			enabled,
			dry_run
        )::deribit.private_toggle_portfolio_margining_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/toggle_portfolio_margining'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_toggle_portfolio_margining_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).currency::text,
		(b).new_state::deribit.private_toggle_portfolio_margining_response_new_state
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_toggle_portfolio_margining is 'Toggle between SM and PM models';

