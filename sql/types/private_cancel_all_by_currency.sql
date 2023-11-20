drop type if exists deribit.private_cancel_all_by_currency_response cascade;
create type deribit.private_cancel_all_by_currency_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_currency_response.result is 'Total number of successfully cancelled orders';

drop type if exists deribit.private_cancel_all_by_currency_request_currency cascade;
create type deribit.private_cancel_all_by_currency_request_currency as enum ('USDC', 'ETH', 'BTC');

drop type if exists deribit.private_cancel_all_by_currency_request_kind cascade;
create type deribit.private_cancel_all_by_currency_request_kind as enum ('option', 'future_combo', 'combo', 'option_combo', 'spot', 'future', 'any');

drop type if exists deribit.private_cancel_all_by_currency_request_type cascade;
create type deribit.private_cancel_all_by_currency_request_type as enum ('trigger_all', 'trailing_stop', 'stop', 'take', 'all', 'limit');

drop type if exists deribit.private_cancel_all_by_currency_request cascade;
create type deribit.private_cancel_all_by_currency_request as (
	currency deribit.private_cancel_all_by_currency_request_currency,
	kind deribit.private_cancel_all_by_currency_request_kind,
	type deribit.private_cancel_all_by_currency_request_type,
	detailed boolean
);
comment on column deribit.private_cancel_all_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.private_cancel_all_by_currency_request.kind is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_all_by_currency_request.type is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_currency_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';

