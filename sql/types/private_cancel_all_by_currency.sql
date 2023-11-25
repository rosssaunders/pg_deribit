drop type if exists deribit.private_cancel_all_by_currency_response cascade;
create type deribit.private_cancel_all_by_currency_response as (
	id bigint,
	jsonrpc text,
	result double precision
);
comment on column deribit.private_cancel_all_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_currency_response.result is 'Total number of successfully cancelled orders';

drop type if exists deribit.private_cancel_all_by_currency_request_currency cascade;
create type deribit.private_cancel_all_by_currency_request_currency as enum ('ETH', 'BTC', 'USDC');

drop type if exists deribit.private_cancel_all_by_currency_request_kind cascade;
create type deribit.private_cancel_all_by_currency_request_kind as enum ('future', 'option_combo', 'future_combo', 'combo', 'spot', 'option', 'any');

drop type if exists deribit.private_cancel_all_by_currency_request_type cascade;
create type deribit.private_cancel_all_by_currency_request_type as enum ('trigger_all', 'stop', 'limit', 'take', 'all', 'trailing_stop');

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

