create type deribit.private_cancel_all_by_kind_or_type_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_by_kind_or_type_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_kind_or_type_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_kind_or_type_response.result is 'Total number of successfully cancelled orders';

create type deribit.private_cancel_all_by_kind_or_type_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo', 'combo', 'any');

create type deribit.private_cancel_all_by_kind_or_type_request_type as enum ('all', 'limit', 'trigger_all', 'stop', 'take', 'trailing_stop');

create type deribit.private_cancel_all_by_kind_or_type_request as (
	currency UNKNOWN - string or array of strings,
	kind deribit.private_cancel_all_by_kind_or_type_request_kind,
	type deribit.private_cancel_all_by_kind_or_type_request_type,
	detailed boolean
);
comment on column deribit.private_cancel_all_by_kind_or_type_request.currency is '(Required) The currency symbol, list of currency symbols or "any" for all';
comment on column deribit.private_cancel_all_by_kind_or_type_request.kind is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_all_by_kind_or_type_request.type is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_kind_or_type_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';

