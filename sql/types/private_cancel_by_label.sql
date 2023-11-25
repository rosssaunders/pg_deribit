drop type if exists deribit.private_cancel_by_label_response cascade;
create type deribit.private_cancel_by_label_response as (
	id bigint,
	jsonrpc text,
	result double precision
);
comment on column deribit.private_cancel_by_label_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_by_label_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_by_label_response.result is 'Total number of successfully cancelled orders';

drop type if exists deribit.private_cancel_by_label_request_currency cascade;
create type deribit.private_cancel_by_label_request_currency as enum ('ETH', 'BTC', 'USDC');

drop type if exists deribit.private_cancel_by_label_request cascade;
create type deribit.private_cancel_by_label_request as (
	label text,
	currency deribit.private_cancel_by_label_request_currency
);
comment on column deribit.private_cancel_by_label_request.label is '(Required) user defined label for the order (maximum 64 characters)';
comment on column deribit.private_cancel_by_label_request.currency is 'The currency symbol';

