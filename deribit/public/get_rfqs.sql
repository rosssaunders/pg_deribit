insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_rfqs', now(), 0, '0 secs'::interval);

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

create or replace function deribit.public_get_rfqs(
	currency deribit.public_get_rfqs_request_currency,
	kind deribit.public_get_rfqs_request_kind default null
)
returns setof deribit.public_get_rfqs_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_rfqs_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		kind
    )::deribit.public_get_rfqs_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_rfqs', _request);

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.public_get_rfqs_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.public_get_rfqs is 'Retrieve active RFQs for instruments in given currency.';

