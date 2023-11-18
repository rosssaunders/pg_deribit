create type deribit.public_get_rfqs_response_result as (
	amount float,
	instrument_name text,
	last_rfq_timestamp bigint,
	side text,
	traded_volume float
);
comment on column deribit.public_get_rfqs_response_result.amount is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_rfqs_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_get_rfqs_response_result.last_rfq_timestamp is 'The timestamp of last RFQ (milliseconds since the Unix epoch)';
comment on column deribit.public_get_rfqs_response_result.side is 'Side - buy or sell';
comment on column deribit.public_get_rfqs_response_result.traded_volume is 'Volume traded since last RFQ';

create type deribit.public_get_rfqs_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_rfqs_response_result[]
);
comment on column deribit.public_get_rfqs_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_rfqs_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_rfqs_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.public_get_rfqs_request_kind as enum ('future', 'option', 'spot', 'future_combo', 'option_combo');

create type deribit.public_get_rfqs_request as (
	currency deribit.public_get_rfqs_request_currency,
	kind deribit.public_get_rfqs_request_kind
);
comment on column deribit.public_get_rfqs_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_rfqs_request.kind is 'Instrument kind, if not provided instruments of all kinds are considered';

