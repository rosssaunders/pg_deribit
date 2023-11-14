insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/cancel_all_by_instrument', null, 0, '0 secs'::interval);

create type deribit.private_cancel_all_by_instrument_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_by_instrument_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_instrument_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_instrument_response.result is 'Total number of successfully cancelled orders';

create type deribit.private_cancel_all_by_instrument_request_type as enum ('all', 'limit', 'trigger_all', 'stop', 'take', 'trailing_stop');

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

create or replace function deribit.private_cancel_all_by_instrument(
	instrument_name text,
	type deribit.private_cancel_all_by_instrument_request_type default null,
	detailed boolean default null,
	include_combos boolean default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_all_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		type,
		detailed,
		include_combos
    )::deribit.private_cancel_all_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_all_by_instrument', _request);

    return (jsonb_populate_record(
        null::deribit.private_cancel_all_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_all_by_instrument is 'Cancels all orders by instrument, optionally filtered by order type.';

