insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_contract_size', now(), 0, '0 secs'::interval);

create type deribit.public_get_contract_size_response_result as (
	contract_size bigint
);
comment on column deribit.public_get_contract_size_response_result.contract_size is 'Contract size, for futures in USD, for options in base currency of the instrument (BTC, ETH, ...)';

create type deribit.public_get_contract_size_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_contract_size_response_result
);
comment on column deribit.public_get_contract_size_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_contract_size_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_contract_size_request as (
	instrument_name text
);
comment on column deribit.public_get_contract_size_request.instrument_name is '(Required) Instrument name';

create or replace function deribit.public_get_contract_size(
	instrument_name text
)
returns deribit.public_get_contract_size_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_contract_size_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name
    )::deribit.public_get_contract_size_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_contract_size', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_contract_size_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_contract_size is 'Retrieves contract size of provided instrument.';

