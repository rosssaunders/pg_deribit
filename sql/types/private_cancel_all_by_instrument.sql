drop type if exists deribit.private_cancel_all_by_instrument_response cascade;
create type deribit.private_cancel_all_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result double precision
);
comment on column deribit.private_cancel_all_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_instrument_response.result is 'Total number of successfully cancelled orders';

drop type if exists deribit.private_cancel_all_by_instrument_request_type cascade;
create type deribit.private_cancel_all_by_instrument_request_type as enum ('all', 'trigger_all', 'limit', 'stop', 'take', 'trailing_stop');

drop type if exists deribit.private_cancel_all_by_instrument_request cascade;
create type deribit.private_cancel_all_by_instrument_request as (
	instrument_name text,
	type deribit.private_cancel_all_by_instrument_request_type,
	detailed boolean,
	include_combos boolean
);
comment on column deribit.private_cancel_all_by_instrument_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_cancel_all_by_instrument_request.type is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_instrument_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_by_instrument_request.include_combos is 'When set to true orders in combo instruments affecting given position will also be cancelled. Default: false';

