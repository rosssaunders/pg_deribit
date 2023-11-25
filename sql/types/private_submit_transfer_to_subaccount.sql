drop type if exists deribit.private_submit_transfer_to_subaccount_response_result cascade;
create type deribit.private_submit_transfer_to_subaccount_response_result as (
	amount double precision,
	created_timestamp bigint,
	currency text,
	direction text,
	id bigint,
	other_side text,
	state text,
	type text,
	updated_timestamp bigint
);
comment on column deribit.private_submit_transfer_to_subaccount_response_result.amount is 'Amount of funds in given currency';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.created_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.direction is 'Transfer direction';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.id is 'Id of transfer';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.other_side is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.state is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.type is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_submit_transfer_to_subaccount_response_result.updated_timestamp is 'The timestamp (milliseconds since the Unix epoch)';

drop type if exists deribit.private_submit_transfer_to_subaccount_response cascade;
create type deribit.private_submit_transfer_to_subaccount_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_submit_transfer_to_subaccount_response_result
);
comment on column deribit.private_submit_transfer_to_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_submit_transfer_to_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_submit_transfer_to_subaccount_request_currency cascade;
create type deribit.private_submit_transfer_to_subaccount_request_currency as enum ('BTC', 'ETH', 'USDC');

drop type if exists deribit.private_submit_transfer_to_subaccount_request cascade;
create type deribit.private_submit_transfer_to_subaccount_request as (
	currency deribit.private_submit_transfer_to_subaccount_request_currency,
	amount double precision,
	destination bigint
);
comment on column deribit.private_submit_transfer_to_subaccount_request.currency is '(Required) The currency symbol';
comment on column deribit.private_submit_transfer_to_subaccount_request.amount is '(Required) Amount of funds to be transferred';
comment on column deribit.private_submit_transfer_to_subaccount_request.destination is '(Required) Id of destination subaccount. Can be found in My Account >> Subaccounts tab';

