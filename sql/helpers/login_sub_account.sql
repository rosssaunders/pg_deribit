create or replace function deribit.switch_to_subaccount(subaccount_id bigint)
returns void
language sql
as
$$
    with tokens as (
        select access_token, refresh_token
        from deribit.public_exchange_token(
            refresh_token := (deribit.get_auth()).refresh_token,
            subject_id := subaccount_id
        )
    )
    select
        deribit.set_access_token_auth(
            access_token := tokens.access_token,
            refresh_token := tokens.refresh_token
        )
    from tokens;
$$;
