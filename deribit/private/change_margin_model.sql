create type deribit.private_change_margin_model_response_old_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float
);
comment on column deribit.private_change_margin_model_response_old_state.available_balance is 'Available balance before change';
comment on column deribit.private_change_margin_model_response_old_state.initial_margin_rate is 'Initial margin rate before change';
comment on column deribit.private_change_margin_model_response_old_state.maintenance_margin_rate is 'Maintenance margin rate before change';

create type deribit.private_change_margin_model_response_new_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float,
	old_state deribit.private_change_margin_model_response_old_state
);
comment on column deribit.private_change_margin_model_response_new_state.available_balance is 'Available balance after change';
comment on column deribit.private_change_margin_model_response_new_state.initial_margin_rate is 'Initial margin rate after change';
comment on column deribit.private_change_margin_model_response_new_state.maintenance_margin_rate is 'Maintenance margin rate after change';
comment on column deribit.private_change_margin_model_response_new_state.old_state is 'Represents portfolio state before change';

create type deribit.private_change_margin_model_response_result as (
	currency text,
	new_state deribit.private_change_margin_model_response_new_state
);
comment on column deribit.private_change_margin_model_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_change_margin_model_response_result.new_state is 'Represents portfolio state after change';

create type deribit.private_change_margin_model_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_change_margin_model_response_result[]
);
comment on column deribit.private_change_margin_model_response.id is 'The id that was sent in the request';
comment on column deribit.private_change_margin_model_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_change_margin_model_request_margin_model as enum ('cross_pm', 'cross_sm', 'segregated_pm', 'segregated_sm', 'legacy_pm');

create type deribit.private_change_margin_model_request as (
	user_id bigint,
	margin_model deribit.private_change_margin_model_request_margin_model,
	dry_run boolean
);
comment on column deribit.private_change_margin_model_request.user_id is 'Id of a (sub)account - by default current user id is used';
comment on column deribit.private_change_margin_model_request.margin_model is '(Required) Margin model';
comment on column deribit.private_change_margin_model_request.dry_run is 'If true request returns the result without switching the margining model. Default: false';

create or replace function deribit.private_change_margin_model(
	user_id bigint default null,
	margin_model deribit.private_change_margin_model_request_margin_model,
	dry_run boolean default null
)
returns deribit.private_change_margin_model_response_result
language plpgsql
as $$
declare
	_request deribit.private_change_margin_model_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		user_id,
		margin_model,
		dry_run
    )::deribit.private_change_margin_model_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/change_margin_model', _request));

    return (jsonb_populate_record(
        null::deribit.private_change_margin_model_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_change_margin_model is 'Change margin model';

