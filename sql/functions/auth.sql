create function deribit.set_client_auth(client_id text, client_secret text)
returns void
language plpgsql
as
$$
begin
    perform omni_var.set('deribit', 'client_id', client_id);
    perform omni_var.set('deribit', 'client_secret', client_secret);
end
$$;

comment on function deribit.set_client_auth is 'Internal function to set deribit API client authentication credentials';

create function deribit.set_access_token_auth(client_id text, client_secret text, access_token text, refresh_token text)
returns void
language plpgsql
as
$$
begin
    perform omni_var.set('deribit', 'access_token', access_token);
    perform omni_var.set('deribit', 'refresh_token', refresh_token);
end
$$;

comment on function deribit.set_access_token_auth is 'Internal function to set deribit API authentication credentials';

create or replace function deribit.get_auth()
returns deribit.auth
language plpgsql
as
$$
declare
    _client_id text;
    _client_secret text;
    _access_token text;
    _refresh_token text;
begin
    begin
        _client_id := omni_var.get('deribit', 'client_id');
    exception when others then
        _client_id := null;
    end;
    
    begin
        _client_secret := omni_var.get('deribit', 'client_secret');
    exception when others then
        _client_secret := null;
    end;
    
    begin
        _access_token := omni_var.get('deribit', 'access_token');
    exception when others then
        _access_token := null;
    end;
    
    begin
        _refresh_token := omni_var.get('deribit', 'refresh_token');
    exception when others then
        _refresh_token := null;
    end;
    
    return row(_client_id, _client_secret, _access_token, _refresh_token)::deribit.auth;
end;
$$;

comment on function deribit.get_auth is 'Internal function to get deribit API authentication credentials';
