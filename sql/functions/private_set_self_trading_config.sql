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

