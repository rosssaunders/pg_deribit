create extension if not exists pg_deribit cascade; --noqa:PRS

-- Login to the main account using client credentials
with client_creds as (
    select
        '<CLIENT_ID>' as client_id,
        '<CLIENT_SECRET>' as client_secret
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
select deribit.set_auth(
        client_creds.client_id,
        client_creds.client_secret,
        public_auth.access_token,
        public_auth.refresh_token
)
from client_creds, public_auth;

select *
from deribit.private_get_subaccounts(false);

select * from deribit.private_create_subaccount();

select *
from deribit.public_exchange_token(
    refresh_token := (deribit.get_auth()).refresh_token,
    subject_id := '12345'
);

select (unnest(summaries)).*
from deribit.private_get_account_summaries(63987, true);

select *
from deribit.private_submit_transfer_to_subaccount(
    amount := 1,
    currency := 'BTC',
    destination := 63987
);

select deribit.set_auth(
'<CLIENT_ID>'::bytea,
'<CLIENT_SECRET>'::bytea,
'<ACCESS_TOKEN'::bytea);

select *
from deribit.private_get_user_trades_by_instrument('BTC-PERPETUAL');

select *
from deribit.private_create_api_key(
    max_scope := 'account:read_write trade:read_write block_trade:read_write wallet:none',
    name := 'trading'
);

select *
from deribit.private_get_subaccounts(true);

select *
from deribit.private_create_subaccount();

select *
from deribit.private_get_subaccounts(true);

select *
from deribit.private_toggle_subaccount_login(
        12345,
        'enable'::deribit.private_toggle_subaccount_login_request_state);

select *
from deribit.private_create_api_key(
    max_scope := 'account:read trade:read block_trade:read_write wallet:none'
);

select deribit.private_create_api_key(
        max_scope := 'account:read trade:read block_trade:read_write wallet:none'
     );

select convert_from((response ->> 'body')::bytea, 'utf8')::jsonb
from deribit.internal_archive ia
order by id desc;
