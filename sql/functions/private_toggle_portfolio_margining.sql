create or replace function deribit.private_toggle_portfolio_margining(
	user_id bigint default null,
	enabled boolean,
	dry_run boolean default null
)
returns setof deribit.private_toggle_portfolio_margining_response_result
language plpgsql
as $$
declare
	_request deribit.private_toggle_portfolio_margining_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		user_id,
		enabled,
		dry_run
    )::deribit.private_toggle_portfolio_margining_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/toggle_portfolio_margining', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.private_toggle_portfolio_margining_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.private_toggle_portfolio_margining is 'Toggle between SM and PM models';

