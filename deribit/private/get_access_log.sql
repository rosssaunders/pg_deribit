insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_access_log', now(), 0, '0 secs'::interval);

create type deribit.private_get_access_log_response_result as (
	city text,
	country text,
	data text,
	id bigint,
	ip text,
	log text,
	timestamp bigint
);
comment on column deribit.private_get_access_log_response_result.city is 'City where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result.country is 'Country where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result.data is 'Optional, additional information about action, type depends on log value';
comment on column deribit.private_get_access_log_response_result.id is 'Unique identifier';
comment on column deribit.private_get_access_log_response_result.ip is 'IP address of source that generated action';
comment on column deribit.private_get_access_log_response_result.log is 'Action description, values: changed_email - email was changed; changed_password - password was changed; disabled_tfa - TFA was disabled; enabled_tfa - TFA was enabled, success - successful login; failure - login failure; enabled_subaccount_login - login was enabled for subaccount (in data - subaccount uid); disabled_subaccount_login - login was disabled for subbaccount (in data - subbacount uid);new_api_key - API key was created (in data key client id); removed_api_key - API key was removed (in data key client id); changed_scope - scope of API key was changed (in data key client id); changed_whitelist - whitelist of API key was edited (in data key client id); disabled_api_key - API key was disabled (in data key client id); enabled_api_key - API key was enabled (in data key client id); reset_api_key - API key was reset (in data key client id)';
comment on column deribit.private_get_access_log_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_access_log_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_access_log_response_result[]
);
comment on column deribit.private_get_access_log_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_access_log_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_access_log_request as (
	"offset" bigint,
	count bigint
);
comment on column deribit.private_get_access_log_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.private_get_access_log_request.count is 'Number of requested items, default - 10';

create or replace function deribit.private_get_access_log(
	"offset" bigint default null,
	count bigint default null
)
returns setof deribit.private_get_access_log_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_access_log_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		"offset",
		count
    )::deribit.private_get_access_log_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_access_log', _request);

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.private_get_access_log_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.private_get_access_log is 'Lists access logs for the user';

