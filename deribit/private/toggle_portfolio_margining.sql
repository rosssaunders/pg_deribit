insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/toggle_portfolio_margining', null, 0, '0 secs'::interval);

create type deribit.private_toggle_portfolio_margining_response_old_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float
);
comment on column deribit.private_toggle_portfolio_margining_response_old_state.available_balance is 'Available balance before change';
comment on column deribit.private_toggle_portfolio_margining_response_old_state.initial_margin_rate is 'Initial margin rate before change';
comment on column deribit.private_toggle_portfolio_margining_response_old_state.maintenance_margin_rate is 'Maintenance margin rate before change';

create type deribit.private_toggle_portfolio_margining_response_new_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float,
	old_state deribit.private_toggle_portfolio_margining_response_old_state
);
comment on column deribit.private_toggle_portfolio_margining_response_new_state.available_balance is 'Available balance after change';
comment on column deribit.private_toggle_portfolio_margining_response_new_state.initial_margin_rate is 'Initial margin rate after change';
comment on column deribit.private_toggle_portfolio_margining_response_new_state.maintenance_margin_rate is 'Maintenance margin rate after change';
comment on column deribit.private_toggle_portfolio_margining_response_new_state.old_state is 'Represents portfolio state before change';

create type deribit.private_toggle_portfolio_margining_response_result as (
	currency text,
	new_state deribit.private_toggle_portfolio_margining_response_new_state
);
comment on column deribit.private_toggle_portfolio_margining_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_toggle_portfolio_margining_response_result.new_state is 'Represents portfolio state after change';

create type deribit.private_toggle_portfolio_margining_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_toggle_portfolio_margining_response_result[]
);
comment on column deribit.private_toggle_portfolio_margining_response.id is 'The id that was sent in the request';
comment on column deribit.private_toggle_portfolio_margining_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_toggle_portfolio_margining_request as (
	user_id bigint,
	enabled boolean,
	dry_run boolean
);
comment on column deribit.private_toggle_portfolio_margining_request.user_id is 'Id of a (sub)account - by default current user id is used';
comment on column deribit.private_toggle_portfolio_margining_request.enabled is '(Required) Whether PM or SM should be enabled - PM while true, SM otherwise';
comment on column deribit.private_toggle_portfolio_margining_request.dry_run is 'If true request returns the result without switching the margining model. Default: false';

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
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.private_toggle_portfolio_margining_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.private_toggle_portfolio_margining is 'Toggle between SM and PM models';

