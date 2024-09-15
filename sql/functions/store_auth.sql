create function deribit.store_auth(client_id bytea, client_secret bytea)
returns void
language plpgsql
as
$$
begin
    -- Store the decrypted text in a session variable
    execute format('set deribit.client_id = ''%s''', convert_from(client_id, 'utf8'));
    execute format('set deribit.client_secret = ''%s''', convert_from(client_secret, 'utf8'));
end
$$;

create or replace function deribit.get_auth()
returns deribit.auth
language sql
as
$$
    select
        row(current_setting('deribit.client_id'), current_setting('deribit.client_secret'))::deribit.auth;
$$;
