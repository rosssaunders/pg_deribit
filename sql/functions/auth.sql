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

create function deribit.set_access_token_auth(client_id text, client_secret text, access_token text, refresh_token text)
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

create or replace function deribit.get_auth()
returns deribit.auth
language sql
as
$$
    select
        row(
            current_setting('deribit.client_id', true), 
            current_setting('deribit.client_secret', true),
            current_setting('deribit.access_token', true),
            current_setting('deribit.refresh_token', true)
            )::deribit.auth;
$$;

comment on function deribit.get_auth is 'Internal function to get deribit API authentication credentials';
