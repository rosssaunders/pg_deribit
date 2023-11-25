drop type if exists deribit.private_get_trigger_order_history_response_entry cascade;
create type deribit.private_get_trigger_order_history_response_entry as (
	amount float,
	direction text,
	instrument_name text,
	label text,
	last_update_timestamp bigint,
	order_id text,
	order_state text,
	order_type text,
	post_only boolean,
	price float,
	reduce_only boolean,
	request text,
	timestamp bigint,
	trigger text,
	trigger_offset float,
	trigger_order_id text,
	trigger_price float
);
comment on column deribit.private_get_trigger_order_history_response_entry.amount is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_trigger_order_history_response_entry.direction is 'Direction: buy, or sell';
comment on column deribit.private_get_trigger_order_history_response_entry.instrument_name is 'Unique instrument identifier';
comment on column deribit.private_get_trigger_order_history_response_entry.label is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_trigger_order_history_response_entry.last_update_timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_trigger_order_history_response_entry.order_id is 'Unique order identifier';
comment on column deribit.private_get_trigger_order_history_response_entry.order_state is 'Order state: "triggered", "cancelled", or "rejected" with rejection reason (e.g. "rejected:reduce_direction").';
comment on column deribit.private_get_trigger_order_history_response_entry.order_type is 'Requested order type: "limit or "market"';
comment on column deribit.private_get_trigger_order_history_response_entry.post_only is 'true for post-only orders only';
comment on column deribit.private_get_trigger_order_history_response_entry.price is 'Price in base currency';
comment on column deribit.private_get_trigger_order_history_response_entry.reduce_only is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_trigger_order_history_response_entry.request is 'Type of last request performed on the trigger order by user or system. "cancel" - when order was cancelled, "trigger:order" - when trigger order spawned market or limit order after being triggered';
comment on column deribit.private_get_trigger_order_history_response_entry.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_trigger_order_history_response_entry.trigger is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_trigger_order_history_response_entry.trigger_offset is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_trigger_order_history_response_entry.trigger_order_id is 'Id of the user order used for the trigger-order reference before triggering';
comment on column deribit.private_get_trigger_order_history_response_entry.trigger_price is 'Trigger price (Only for future trigger orders)';

drop type if exists deribit.private_get_trigger_order_history_response_result cascade;
create type deribit.private_get_trigger_order_history_response_result as (
	continuation text,
	entries deribit.private_get_trigger_order_history_response_entry[]
);
comment on column deribit.private_get_trigger_order_history_response_result.continuation is 'Continuation token for pagination.';

drop type if exists deribit.private_get_trigger_order_history_response cascade;
create type deribit.private_get_trigger_order_history_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_trigger_order_history_response_result
);
comment on column deribit.private_get_trigger_order_history_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_trigger_order_history_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_get_trigger_order_history_request_currency cascade;
create type deribit.private_get_trigger_order_history_request_currency as enum ('BTC', 'ETH', 'USDC');

drop type if exists deribit.private_get_trigger_order_history_request cascade;
create type deribit.private_get_trigger_order_history_request as (
	currency deribit.private_get_trigger_order_history_request_currency,
	instrument_name text,
	count bigint,
	continuation text
);
comment on column deribit.private_get_trigger_order_history_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_trigger_order_history_request.instrument_name is 'Instrument name';
comment on column deribit.private_get_trigger_order_history_request.count is 'Number of requested items, default - 20';
comment on column deribit.private_get_trigger_order_history_request.continuation is 'Continuation token for pagination';

