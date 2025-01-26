create or replace function deribit.login_main_account(client_id text, client_secret text)
returns void
language sql
as
$$
    with client_creds as (
        select
            client_id,
            client_secret
    ),
    public_auth as (
        select client_id, client_secret, access_token, refresh_token
        from client_creds, deribit.public_auth(
            grant_type := 'client_credentials',
            client_id := client_id,
            client_secret := client_secret,
            refresh_token := null, -- not required for client_credentials
            "timestamp" := 0, -- not required for client_credentials
            signature := null -- not required for client_credentials
        )
    )
    select
        deribit.set_access_token_auth(
            access_token := public_auth.access_token,
            refresh_token := public_auth.refresh_token
        )
    from client_creds, public_auth;
$$;
