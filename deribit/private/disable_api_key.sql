insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/disable_api_key', now(), 0, '0 secs'::interval);

create type deribit.private_disable_api_key_response_result as (
	client_id text,
	client_secret text,
	"default" boolean,
	enabled boolean,
	enabled_features text[],
	id bigint,
	max_scope text,
	name text,
	public_key text,
	timestamp bigint
);
comment on column deribit.private_disable_api_key_response_result.client_id is 'Client identifier used for authentication';
comment on column deribit.private_disable_api_key_response_result.client_secret is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_disable_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_disable_api_key_response_result.enabled is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_disable_api_key_response_result.enabled_features is 'List of enabled advanced on-key features. Available options: - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key';
comment on column deribit.private_disable_api_key_response_result.id is 'key identifier';
comment on column deribit.private_disable_api_key_response_result.max_scope is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, it value is set as none. Please check details described in Access scope';
comment on column deribit.private_disable_api_key_response_result.name is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_disable_api_key_response_result.public_key is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_disable_api_key_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_disable_api_key_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_disable_api_key_response_result
);
comment on column deribit.private_disable_api_key_response.id is 'The id that was sent in the request';
comment on column deribit.private_disable_api_key_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_disable_api_key_request as (
	id bigint
);
comment on column deribit.private_disable_api_key_request.id is '(Required) Id of key';

create or replace function deribit.private_disable_api_key(
	id bigint
)
returns deribit.private_disable_api_key_response_result
language plpgsql
as $$
declare
	_request deribit.private_disable_api_key_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		id
    )::deribit.private_disable_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/disable_api_key', _request);

    return (jsonb_populate_record(
        null::deribit.private_disable_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_disable_api_key is 'Disables api key with given id. Important notes.';

