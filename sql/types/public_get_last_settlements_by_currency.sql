drop type if exists deribit.public_get_last_settlements_by_currency_response_settlement cascade;
create type deribit.public_get_last_settlements_by_currency_response_settlement as (
	funded float,
	funding float,
	index_price float,
	instrument_name text,
	mark_price float,
	position float,
	profit_loss float,
	session_bankrupcy float,
	session_profit_loss float,
	session_tax float,
	session_tax_rate float,
	socialized float,
	timestamp bigint,
	type text
);
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.funded is 'funded amount (bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.funding is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.index_price is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.instrument_name is 'instrument name (settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.mark_price is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.position is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.profit_loss is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.session_bankrupcy is 'value of session bankrupcy (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.session_profit_loss is 'total value of session profit and losses (in base currency)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.session_tax is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.session_tax_rate is 'rate of paid texes/fees (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.socialized is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement.type is 'The type of settlement. settlement, delivery or bankruptcy.';

drop type if exists deribit.public_get_last_settlements_by_currency_response_result cascade;
create type deribit.public_get_last_settlements_by_currency_response_result as (
	continuation text,
	settlements deribit.public_get_last_settlements_by_currency_response_settlement[]
);
comment on column deribit.public_get_last_settlements_by_currency_response_result.continuation is 'Continuation token for pagination.';

drop type if exists deribit.public_get_last_settlements_by_currency_response cascade;
create type deribit.public_get_last_settlements_by_currency_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_last_settlements_by_currency_response_result
);
comment on column deribit.public_get_last_settlements_by_currency_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_last_settlements_by_currency_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_last_settlements_by_currency_request_currency cascade;
create type deribit.public_get_last_settlements_by_currency_request_currency as enum ('BTC', 'ETH', 'USDC');

drop type if exists deribit.public_get_last_settlements_by_currency_request_type cascade;
create type deribit.public_get_last_settlements_by_currency_request_type as enum ('settlement', 'bankruptcy', 'delivery');

drop type if exists deribit.public_get_last_settlements_by_currency_request cascade;
create type deribit.public_get_last_settlements_by_currency_request as (
	currency deribit.public_get_last_settlements_by_currency_request_currency,
	type deribit.public_get_last_settlements_by_currency_request_type,
	count bigint,
	continuation text,
	search_start_timestamp bigint
);
comment on column deribit.public_get_last_settlements_by_currency_request.currency is '(Required) The currency symbol';
comment on column deribit.public_get_last_settlements_by_currency_request.type is 'Settlement type';
comment on column deribit.public_get_last_settlements_by_currency_request.count is 'Number of requested items, default - 20';
comment on column deribit.public_get_last_settlements_by_currency_request.continuation is 'Continuation token for pagination';
comment on column deribit.public_get_last_settlements_by_currency_request.search_start_timestamp is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

