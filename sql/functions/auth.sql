create function deribit.set_client_auth(client_id text, client_secret text)
returns void
language plpgsql
as
$$
begin
    execute format('set deribit.client_id = ''%s''', client_id);
    execute format('set deribit.client_secret = ''%s''', client_secret);
end
$$;

comment on function deribit.set_client_auth is 'Internal function to set deribit API client authentication credentials';

create function deribit.set_access_token_auth(access_token text, refresh_token text)
returns void
language plpgsql
as
$$
begin
    execute format('set deribit.access_token = ''%s''', access_token);
    execute format('set deribit.refresh_token = ''%s''', refresh_token);
end
$$;

comment on function deribit.set_access_token_auth is 'Internal function to set deribit API authentication credentials';

create or replace function deribit.get_auth(credential_name text default 'deribit')
returns deribit.auth
language plpgsql
stable
as
$$
declare
    _auth deribit.auth;
    _session_client_id text;
    _session_client_secret text;
    _session_access_token text;
    _session_refresh_token text;
begin
    -- First, try to get from session variables
    _session_client_id := current_setting('deribit.client_id', true);
    _session_client_secret := current_setting('deribit.client_secret', true);
    _session_access_token := current_setting('deribit.access_token', true);
    _session_refresh_token := current_setting('deribit.refresh_token', true);

    -- If we have session variables, use them (backwards compatibility)
    if _session_client_id is not null or _session_access_token is not null then
        return row(
            _session_client_id,
            _session_client_secret,
            _session_access_token,
            _session_refresh_token
        )::deribit.auth;
    end if;

    -- Otherwise, try to get from omni_credentials store
    _auth := deribit.get_credentials_from_store(credential_name);
    
    if _auth is not null then
        return _auth;
    end if;

    -- Return empty auth if nothing found
    return row(null, null, null, null)::deribit.auth;
end;
$$;

comment on function deribit.get_auth is 'Get deribit API authentication credentials from session variables or omni_credentials store';
