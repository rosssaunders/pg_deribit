insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/cancel_all', now(), 0, '0 secs'::interval);

create type deribit.private_cancel_all_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_all_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_response.result is 'Total number of successfully cancelled orders';

create type deribit.private_cancel_all_request as (
	detailed boolean
);
comment on column deribit.private_cancel_all_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';

create or replace function deribit.private_cancel_all(
	detailed boolean default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_all_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		detailed
    )::deribit.private_cancel_all_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_all', _request);

    return (jsonb_populate_record(
        null::deribit.private_cancel_all_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_all is 'This method cancels all users orders and trigger orders within all currencies and instrument kinds.';

