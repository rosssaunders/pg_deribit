drop type if exists deribit.private_change_margin_model_response_old_state cascade;
create type deribit.private_change_margin_model_response_old_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float
);
comment on column deribit.private_change_margin_model_response_old_state.available_balance is 'Available balance before change';
comment on column deribit.private_change_margin_model_response_old_state.initial_margin_rate is 'Initial margin rate before change';
comment on column deribit.private_change_margin_model_response_old_state.maintenance_margin_rate is 'Maintenance margin rate before change';

drop type if exists deribit.private_change_margin_model_response_new_state cascade;
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

drop type if exists deribit.private_change_margin_model_response_result cascade;
create type deribit.private_change_margin_model_response_result as (
	currency text,
	new_state deribit.private_change_margin_model_response_new_state
);
comment on column deribit.private_change_margin_model_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_change_margin_model_response_result.new_state is 'Represents portfolio state after change';

drop type if exists deribit.private_change_margin_model_response cascade;
create type deribit.private_change_margin_model_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_change_margin_model_response_result[]
);
comment on column deribit.private_change_margin_model_response.id is 'The id that was sent in the request';
comment on column deribit.private_change_margin_model_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_change_margin_model_request_margin_model cascade;
create type deribit.private_change_margin_model_request_margin_model as enum ('segregated_sm', 'cross_pm', 'cross_sm', 'legacy_pm', 'segregated_pm');

drop type if exists deribit.private_change_margin_model_request cascade;
create type deribit.private_change_margin_model_request as (
	user_id bigint,
	margin_model deribit.private_change_margin_model_request_margin_model,
	dry_run boolean
);
comment on column deribit.private_change_margin_model_request.user_id is 'Id of a (sub)account - by default current user id is used';
comment on column deribit.private_change_margin_model_request.margin_model is '(Required) Margin model';
comment on column deribit.private_change_margin_model_request.dry_run is 'If true request returns the result without switching the margining model. Default: false';

