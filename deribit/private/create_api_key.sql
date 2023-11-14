insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/create_api_key', null, 0, '0 secs'::interval);

create type deribit.private_create_api_key_response_result as (
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
comment on column deribit.private_create_api_key_response_result.client_id is 'Client identifier used for authentication';
comment on column deribit.private_create_api_key_response_result.client_secret is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_create_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_create_api_key_response_result.enabled is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_create_api_key_response_result.enabled_features is 'List of enabled advanced on-key features. Available options: - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key';
comment on column deribit.private_create_api_key_response_result.id is 'key identifier';
comment on column deribit.private_create_api_key_response_result.max_scope is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, it value is set as none. Please check details described in Access scope';
comment on column deribit.private_create_api_key_response_result.name is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_create_api_key_response_result.public_key is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_create_api_key_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_create_api_key_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_create_api_key_response_result
);
comment on column deribit.private_create_api_key_response.id is 'The id that was sent in the request';
comment on column deribit.private_create_api_key_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_create_api_key_request as (
	max_scope text,
	name text,
	public_key text,
	enabled_features text[]
);
comment on column deribit.private_create_api_key_request.max_scope is '(Required) Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, it value is set as none. Please check details described in Access scope';
comment on column deribit.private_create_api_key_request.name is 'Name of key (only letters, numbers and underscores allowed; maximum length - 16 characters)';
comment on column deribit.private_create_api_key_request.public_key is 'ED25519 or RSA PEM Encoded public key that should be used to create asymmetric API Key for signing requests/authentication requests with user''s private key.';
comment on column deribit.private_create_api_key_request.enabled_features is 'List of enabled advanced on-key features. Available options: - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key';

create or replace function deribit.private_create_api_key(
	max_scope text,
	name text default null,
	public_key text default null,
	enabled_features text[] default null
)
returns deribit.private_create_api_key_response_result
language plpgsql
as $$
declare
	_request deribit.private_create_api_key_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		max_scope,
		name,
		public_key,
		enabled_features
    )::deribit.private_create_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/create_api_key', _request);

    return (jsonb_populate_record(
        null::deribit.private_create_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_create_api_key is 'Creates new api key with given scope. Important notes';

