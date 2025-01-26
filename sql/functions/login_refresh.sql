create or replace function deribit.refresh_auth_tokens()
returns void
language sql
as
$$
    with tokens as (
        select *
        from deribit.public_auth(
            grant_type := 'refresh_token',
            refresh_token := (deribit.get_auth()).refresh_token,
            client_id := '',
            client_secret := '',
            "timestamp" := 0, -- not required for client_credentials
            signature := null -- not required for client_credentials
        )
    )
    select
        deribit.set_access_token_auth(
            access_token := tokens.access_token,
            refresh_token := tokens.refresh_token
        )
    from tokens;
$$;
