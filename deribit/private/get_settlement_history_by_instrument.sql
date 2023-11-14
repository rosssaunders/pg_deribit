insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_settlement_history_by_instrument', null, 0, '0 secs'::interval);

create type deribit.private_get_settlement_history_by_instrument_response_settlement as (
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
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.funded is 'funded amount (bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.funding is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.index_price is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.instrument_name is 'instrument name (settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.mark_price is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.position is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.profit_loss is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_bankrupcy is 'value of session bankrupcy (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_profit_loss is 'total value of session profit and losses (in base currency)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_tax is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.session_tax_rate is 'rate of paid texes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.socialized is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement.type is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.private_get_settlement_history_by_instrument_response_result as (
	continuation text,
	settlements deribit.private_get_settlement_history_by_instrument_response_settlement[]
);
comment on column deribit.private_get_settlement_history_by_instrument_response_result.continuation is 'Continuation token for pagination.';

create type deribit.private_get_settlement_history_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_settlement_history_by_instrument_response_result
);
comment on column deribit.private_get_settlement_history_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_settlement_history_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_settlement_history_by_instrument_request_type as enum ('settlement', 'delivery', 'bankruptcy');

create type deribit.private_get_settlement_history_by_instrument_request as (
	instrument_name text,
	type deribit.private_get_settlement_history_by_instrument_request_type,
	count bigint,
	continuation text,
	search_start_timestamp bigint
);
comment on column deribit.private_get_settlement_history_by_instrument_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_get_settlement_history_by_instrument_request.type is 'Settlement type';
comment on column deribit.private_get_settlement_history_by_instrument_request.count is 'Number of requested items, default - 20';
comment on column deribit.private_get_settlement_history_by_instrument_request.continuation is 'Continuation token for pagination';
comment on column deribit.private_get_settlement_history_by_instrument_request.search_start_timestamp is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create or replace function deribit.private_get_settlement_history_by_instrument(
	instrument_name text,
	type deribit.private_get_settlement_history_by_instrument_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.private_get_settlement_history_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_settlement_history_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		type,
		count,
		continuation,
		search_start_timestamp
    )::deribit.private_get_settlement_history_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_settlement_history_by_instrument', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_settlement_history_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_settlement_history_by_instrument is 'Retrieves public settlement, delivery and bankruptcy events filtered by instrument name';

