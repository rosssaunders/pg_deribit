drop type if exists deribit.private_get_user_locks_response_result cascade;
create type deribit.private_get_user_locks_response_result as (
	currency text,
	enabled boolean,
	message text
);
comment on column deribit.private_get_user_locks_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_locks_response_result.enabled is 'Value is set to ''true'' when user account is locked in currency';
comment on column deribit.private_get_user_locks_response_result.message is 'Optional information for user why his account is locked';

drop type if exists deribit.private_get_user_locks_response cascade;
create type deribit.private_get_user_locks_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_user_locks_response_result[]
);
comment on column deribit.private_get_user_locks_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_user_locks_response.jsonrpc is 'The JSON-RPC version (2.0)';

