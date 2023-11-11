create type deribit.private_list_api_keys_response_result as (
	client_id text,
	client_secret text,
	"default" boolean,
	enabled boolean,
	enabled_features UNKNOWN - array of string,
	id bigint,
	max_scope text,
	name text,
	public_key text,
	timestamp bigint
);
comment on column deribit.private_list_api_keys_response_result.client_id is 'Client identifier used for authentication';
comment on column deribit.private_list_api_keys_response_result.client_secret is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_list_api_keys_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_list_api_keys_response_result.enabled is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_list_api_keys_response_result.enabled_features is 'List of enabled advanced on-key features. Available options: - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key';
comment on column deribit.private_list_api_keys_response_result.id is 'key identifier';
comment on column deribit.private_list_api_keys_response_result.max_scope is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, it value is set as none. Please check details described in Access scope';
comment on column deribit.private_list_api_keys_response_result.name is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_list_api_keys_response_result.public_key is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_list_api_keys_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_list_api_keys_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_list_api_keys_response_result[]
);
comment on column deribit.private_list_api_keys_response.id is 'The id that was sent in the request';
comment on column deribit.private_list_api_keys_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_list_api_keys()
returns deribit.private_list_api_keys_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
    _error_response deribit.error_response;
begin
    
    with request as (
        select json_build_object(
            'method', '/private/list_api_keys',
            'params', null,
            'jsonrpc', '2.0',
            'id', nextval('deribit.jsonrpc_identifier'::regclass)
        ) as request
    ),
    auth as (
        select
            'Authorization' as key,
            'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value
    ),
    url as (
        select format('%s%s', base_url, end_point) as url
        from
        (
            select
                'https://test.deribit.com/api/v2' as base_url,
                '/private/list_api_keys' as end_point
        ) as a
    )
    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from request
    cross join auth
    cross join url
    cross join omni_httpc.http_execute(
        omni_httpc.http_request(
            method := 'POST',
            url := url.url,
            body := request.request::text::bytea,
            headers := array[row (auth.key, auth.value)::omni_http.http_header])
    ) as response
    limit 1;
    
    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
             case
                when (_error_response.error).data is null then ''
                 else ':' || (_error_response.error).data
             end;
    end if;
    
    return (jsonb_populate_record(
        null::deribit.private_list_api_keys_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_list_api_keys is 'Retrieves list of api keys. Important notes.';

