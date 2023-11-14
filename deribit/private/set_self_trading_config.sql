insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/set_self_trading_config', null, 0, '0 secs'::interval);

create type deribit.private_set_self_trading_config_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_self_trading_config_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_self_trading_config_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_self_trading_config_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_set_self_trading_config_request_mode as enum ('reject_taker', 'cancel_maker');

create type deribit.private_set_self_trading_config_request as (
	mode deribit.private_set_self_trading_config_request_mode,
	extended_to_subaccounts boolean
);
comment on column deribit.private_set_self_trading_config_request.mode is '(Required) Self trading prevention behavior: reject_taker (reject the incoming order), cancel_maker (cancel the matched order in the book)';
comment on column deribit.private_set_self_trading_config_request.extended_to_subaccounts is '(Required) If value is true trading is prevented between subaccounts of given account, otherwise they are treated separately';

create or replace function deribit.private_set_self_trading_config(
	mode deribit.private_set_self_trading_config_request_mode,
	extended_to_subaccounts boolean
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_set_self_trading_config_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		mode,
		extended_to_subaccounts
    )::deribit.private_set_self_trading_config_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/set_self_trading_config', _request);

    return (jsonb_populate_record(
        null::deribit.private_set_self_trading_config_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_set_self_trading_config is 'Configure self trading behavior';

