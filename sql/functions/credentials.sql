-- Check if omni_credentials extension is available
create or replace function deribit.has_omni_credentials()
returns boolean
language sql
stable
as $$
    select exists(
        select 1
        from pg_extension
        where extname = 'omni_credentials'
    );
$$;

comment on function deribit.has_omni_credentials is 'Check if omni_credentials extension is available';

-- Get credentials from omni_credentials store
-- Returns NULL if omni_credentials is not available or credentials not found
create or replace function deribit.get_credentials_from_store(credential_name text default 'deribit')
returns deribit.auth
language plpgsql
stable
security definer
as $$
declare
    _client_id text;
    _client_secret text;
    _access_token text;
    _refresh_token text;
    _has_creds boolean;
begin
    -- Check if omni_credentials is available
    if not deribit.has_omni_credentials() then
        return null;
    end if;

    -- Try to get credentials from omni_credentials
    -- We expect credentials to be stored with specific names:
    -- - {credential_name}_client_id
    -- - {credential_name}_client_secret
    -- - {credential_name}_access_token (optional)
    -- - {credential_name}_refresh_token (optional)
    begin
        execute format('
            select 
                max(case when name = %L then convert_from(value, ''utf8'') end),
                max(case when name = %L then convert_from(value, ''utf8'') end),
                max(case when name = %L then convert_from(value, ''utf8'') end),
                max(case when name = %L then convert_from(value, ''utf8'') end)
            from omni_credentials.credentials
            where name in (%L, %L, %L, %L)
        ', 
            credential_name || '_client_id',
            credential_name || '_client_secret',
            credential_name || '_access_token',
            credential_name || '_refresh_token',
            credential_name || '_client_id',
            credential_name || '_client_secret',
            credential_name || '_access_token',
            credential_name || '_refresh_token'
        ) into _client_id, _client_secret, _access_token, _refresh_token;

        -- Return auth record if we have at least client credentials
        if _client_id is not null or _access_token is not null then
            return row(_client_id, _client_secret, _access_token, _refresh_token)::deribit.auth;
        end if;
    exception
        when others then
            -- If there's any error accessing omni_credentials, return null
            return null;
    end;

    return null;
end;
$$;

comment on function deribit.get_credentials_from_store is 'Get Deribit credentials from omni_credentials store';

-- Store credentials in omni_credentials
create or replace function deribit.store_credentials(
    client_id text,
    client_secret text,
    credential_name text default 'deribit',
    access_token text default null,
    refresh_token text default null
)
returns void
language plpgsql
security definer
as $$
begin
    -- Check if omni_credentials is available
    if not deribit.has_omni_credentials() then
        raise exception 'omni_credentials extension is not installed. Install it first with: CREATE EXTENSION omni_credentials;';
    end if;

    -- Delete existing credentials with the same name
    execute format('
        delete from omni_credentials.credentials
        where name in (%L, %L, %L, %L)
    ',
        credential_name || '_client_id',
        credential_name || '_client_secret',
        credential_name || '_access_token',
        credential_name || '_refresh_token'
    );

    -- Insert client credentials
    if client_id is not null then
        execute format('
            insert into omni_credentials.credentials (name, value)
            values (%L, %L::bytea)
        ', credential_name || '_client_id', client_id);
    end if;

    if client_secret is not null then
        execute format('
            insert into omni_credentials.credentials (name, value)
            values (%L, %L::bytea)
        ', credential_name || '_client_secret', client_secret);
    end if;

    -- Insert access tokens if provided
    if access_token is not null then
        execute format('
            insert into omni_credentials.credentials (name, value)
            values (%L, %L::bytea)
        ', credential_name || '_access_token', access_token);
    end if;

    if refresh_token is not null then
        execute format('
            insert into omni_credentials.credentials (name, value)
            values (%L, %L::bytea)
        ', credential_name || '_refresh_token', refresh_token);
    end if;
end;
$$;

comment on function deribit.store_credentials is 'Store Deribit credentials in omni_credentials. Requires omni_credentials extension.';
