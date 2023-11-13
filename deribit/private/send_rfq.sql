insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/send_rfq', now(), 0, '0 secs'::interval);

create type deribit.private_send_rfq_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_send_rfq_response.id is 'The id that was sent in the request';
comment on column deribit.private_send_rfq_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_send_rfq_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_send_rfq_request_side as enum ('buy', 'sell');

create type deribit.private_send_rfq_request as (
	instrument_name text,
	amount float,
	side deribit.private_send_rfq_request_side
);
comment on column deribit.private_send_rfq_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_send_rfq_request.amount is 'Amount';
comment on column deribit.private_send_rfq_request.side is 'Side - buy or sell';

create or replace function deribit.private_send_rfq(
	instrument_name text,
	amount float default null,
	side deribit.private_send_rfq_request_side default null
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_send_rfq_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		amount,
		side
    )::deribit.private_send_rfq_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/send_rfq', _request);

    return (jsonb_populate_record(
        null::deribit.private_send_rfq_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';

