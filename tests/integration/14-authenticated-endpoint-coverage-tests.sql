-- Authenticated Endpoint Coverage Tests (TestNet)
-- Exercises remaining authenticated endpoints with realistic parameters.
-- Requires DERIBIT_CLIENT_ID and DERIBIT_CLIENT_SECRET to be set.

create extension if not exists pgtap;
create extension if not exists pg_deribit cascade;

\c

begin;

-- Setup: Enable TestNet and set authentication
select deribit.enable_test_net();

create or replace function pg_temp.test_first_enum(anyenum)
returns anyenum
language sql
as $$
    select unnest(enum_range($1)) limit 1
$$;

create temporary table auth_creds(
    client_id text,
    client_secret text
);

DO $$
DECLARE
    v_client_id text;
    v_client_secret text;
BEGIN
    BEGIN
        v_client_id := current_setting('deribit.test_client_id');
        v_client_secret := current_setting('deribit.test_client_secret');
    EXCEPTION WHEN undefined_object THEN
        RAISE EXCEPTION 'Authentication credentials not found. Set via: ALTER DATABASE deribit SET deribit.test_client_id = ''your_id'';';
    END;

    INSERT INTO auth_creds VALUES (v_client_id, v_client_secret);
    PERFORM deribit.set_client_auth(v_client_id, v_client_secret);
END $$;

create temporary table auth_ctx as
select
    'BTC'::text as currency,
    'btc_usdc'::text as currency_pair,
    'BTC-PERPETUAL'::text as instrument_name,
    null::bigint as instrument_id,
    (select name
     from deribit.public_get_index_price_names(true)
     where name ilike 'btc_%'
     order by name
     limit 1) as index_name,
    (extract(epoch from clock_timestamp()) * 1000)::bigint as now_ms,
    (extract(epoch from clock_timestamp()) * 1000 - 3600 * 1000)::bigint as start_ms,
    (extract(epoch from clock_timestamp()) * 1000 - 86400 * 1000)::bigint as day_ms,
    to_char(clock_timestamp(), 'YYYYMMDDHH24MISSMS') as label_suffix,
    substring(to_char(clock_timestamp(), 'YYYYMMDDHH24MISSMS') from 1 for 8) as short_suffix;

create temporary table token_ctx as
select
    (deribit.public_auth(
        'client_credentials',
        (select client_id from auth_creds),
        (select client_secret from auth_creds),
        null,
        null,
        null,
        null,
        null,
        null,
        null
    )).refresh_token as refresh_token;

create temporary table order_ctx as
select
    ((deribit.private_buy(
        instrument_name => (select instrument_name from auth_ctx),
        amount => 10,
        type => 'limit',
        time_in_force => 'good_til_cancelled',
        post_only => true,
        price => 10000.0,
        reject_post_only => false,
        label => 'pgtap_cov_order_' || (select label_suffix from auth_ctx)
    ))."order").order_id as order_id,
    'pgtap_cov_order_' || (select label_suffix from auth_ctx) as label;

create temporary table api_key_ctx(
    api_key_id text,
    api_key_name text,
    can_manage_api_keys boolean
);

DO $$
DECLARE
    v_api_key_id text;
    v_can_manage_api_keys boolean := true;
BEGIN
    BEGIN
        v_api_key_id := (deribit.private_create_api_key(
            max_scope => 'trade:read_write, wallet:read, account:read, block_trade:read',
            name => 'pgtap' || (select short_suffix from auth_ctx)
        )).id;
    EXCEPTION WHEN OTHERS THEN
        -- Some credentials lack account:read_write; allow and continue.
        IF SQLERRM NOT LIKE '%required scope account:read_write%'
           AND SQLERRM NOT LIKE '%forbidden%'
           AND SQLERRM NOT LIKE '%13021%' THEN
            RAISE;
        END IF;
        v_api_key_id := null;
        v_can_manage_api_keys := false;
    END;

    INSERT INTO api_key_ctx(api_key_id, api_key_name, can_manage_api_keys)
    VALUES (v_api_key_id, 'pgtap' || (select short_suffix from auth_ctx), v_can_manage_api_keys);
END $$;

create temporary table subaccount_ctx(
    subaccount_id text,
    subaccount_id_2 text,
    can_manage_subaccounts boolean
);

DO $$
DECLARE
    v_subaccount_id text;
    v_subaccount_id_2 text;
    v_can_manage_subaccounts boolean := true;
BEGIN
    BEGIN
        v_subaccount_id := (deribit.private_create_subaccount()).id;
        v_subaccount_id_2 := (deribit.private_create_subaccount()).id;
    EXCEPTION WHEN OTHERS THEN
        -- Some credentials lack account:read_write; allow and continue.
        IF SQLERRM NOT LIKE '%required scope account:read_write%'
           AND SQLERRM NOT LIKE '%forbidden%'
           AND SQLERRM NOT LIKE '%13021%' THEN
            RAISE;
        END IF;
        v_subaccount_id := null;
        v_subaccount_id_2 := null;
        v_can_manage_subaccounts := false;
    END;

    INSERT INTO subaccount_ctx(subaccount_id, subaccount_id_2, can_manage_subaccounts)
    VALUES (v_subaccount_id, v_subaccount_id_2, v_can_manage_subaccounts);
END $$;

create temporary table address_ctx as
select
    'tb1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh'::text as address,
    'pgtap_addr_' || (select short_suffix from auth_ctx) as label,
    'did:test:vasp'::text as vasp_did,
    'TestVASP'::text as vasp_name;

create temporary table announcement_ctx as
select
    (select id from deribit.public_get_announcements((select day_ms from auth_ctx), 1) limit 1) as announcement_id;

create temporary table endpoint_test_cases(
    seq integer,
    name text,
    sql text,
    allowed_errors text[]
);

insert into endpoint_test_cases(seq, name, sql, allowed_errors) values
    (10, 'public_auth',
     $$select deribit.public_auth('client_credentials', (select client_id from auth_creds), (select client_secret from auth_creds), null, null, null, null, null, null, null)$$,
     ARRAY[]::text[]),
    (20, 'public_exchange_token',
     $$select deribit.public_exchange_token((select refresh_token from token_ctx), null, null)$$,
     ARRAY['%-32602%']),
    (30, 'public_fork_token',
     $$select deribit.public_fork_token((select refresh_token from token_ctx), 'pgtap_session')$$,
     ARRAY[]::text[]),

    (100, 'private_get_account_summary',
     $$select deribit.private_get_account_summary(pg_temp.test_first_enum(null::deribit.private_get_account_summary_request_currency), null, true)$$,
     ARRAY[]::text[]),
    (110, 'private_get_account_summaries',
     $$select deribit.private_get_account_summaries(null, true)$$,
     ARRAY[]::text[]),
    (120, 'private_get_positions',
     $$select deribit.private_get_positions(pg_temp.test_first_enum(null::deribit.private_get_positions_request_currency), pg_temp.test_first_enum(null::deribit.private_get_positions_request_kind), null)$$,
     ARRAY[]::text[]),
    (130, 'private_get_position',
     $$select deribit.private_get_position((select instrument_name from auth_ctx))$$,
     ARRAY[]::text[]),
    (140, 'private_get_user_locks',
     $$select deribit.private_get_user_locks()$$,
     ARRAY[]::text[]),
    (150, 'private_get_access_log',
     $$select deribit.private_get_access_log(0, 10)$$,
     ARRAY['%expected JSON array%']),
    (160, 'private_get_transaction_log',
     $$select deribit.private_get_transaction_log(pg_temp.test_first_enum(null::deribit.private_get_transaction_log_request_currency), (select day_ms from auth_ctx), (select now_ms from auth_ctx), null, 10, null, null)$$,
     ARRAY[]::text[]),
    (170, 'private_get_transfers',
     $$select deribit.private_get_transfers(pg_temp.test_first_enum(null::deribit.private_get_transfers_request_currency), 10, 0)$$,
     ARRAY[]::text[]),
    (180, 'private_get_deposits',
     $$select deribit.private_get_deposits(pg_temp.test_first_enum(null::deribit.private_get_deposits_request_currency), 10, 0)$$,
     ARRAY[]::text[]),
    (190, 'private_get_withdrawals',
     $$select deribit.private_get_withdrawals(pg_temp.test_first_enum(null::deribit.private_get_withdrawals_request_currency), 10, 0)$$,
     ARRAY[]::text[]),
    (200, 'private_get_current_deposit_address',
     $$select deribit.private_get_current_deposit_address(pg_temp.test_first_enum(null::deribit.private_get_current_deposit_address_request_currency))$$,
     ARRAY['%not found%','%not_available%','%forbidden%']),
    (210, 'private_create_deposit_address',
     $$select deribit.private_create_deposit_address(pg_temp.test_first_enum(null::deribit.private_create_deposit_address_request_currency))$$,
     ARRAY['%not supported%','%not_available%','%forbidden%','%invalid%','%13021%']),

    (220, 'private_get_email_language',
     $$select deribit.private_get_email_language()$$,
     ARRAY[]::text[]),
    (230, 'private_set_email_language',
     $$select deribit.private_set_email_language('en')$$,
     ARRAY['%13021%']),

    (240, 'private_get_new_announcements',
     $$select deribit.private_get_new_announcements()$$,
     ARRAY[]::text[]),
    (250, 'private_set_announcement_as_read',
     $$select deribit.private_set_announcement_as_read(coalesce((select announcement_id from announcement_ctx), 0))$$,
     ARRAY['%announcement%','%not found%','%invalid%']),

    (260, 'private_get_reward_eligibility',
     $$select deribit.private_get_reward_eligibility()$$,
     ARRAY[]::text[]),
    (270, 'private_get_margins',
     $$select deribit.private_get_margins((select instrument_name from auth_ctx), 10, 10000.0)$$,
     ARRAY[]::text[]),
    (280, 'private_get_leg_prices',
     $$select deribit.private_get_leg_prices('[]'::jsonb, 10000.0)$$,
     ARRAY['%invalid%','%legs%','%-32602%']),

    (300, 'private_pme_simulate',
     $$select deribit.private_pme_simulate(pg_temp.test_first_enum(null::deribit.private_pme_simulate_request_currency), true, jsonb_build_object((select instrument_name from auth_ctx), 1))$$,
     ARRAY['%forbidden%','%not enabled%']),
    (310, 'private_simulate_portfolio',
     $$select deribit.private_simulate_portfolio(pg_temp.test_first_enum(null::deribit.private_simulate_portfolio_request_currency), true, jsonb_build_object((select instrument_name from auth_ctx), 1))$$,
     ARRAY['%forbidden%','%not enabled%']),

    (320, 'private_get_mmp_config',
     $$select deribit.private_get_mmp_config((select unnest(enum_range(null::deribit.private_get_mmp_config_request_index_name)) limit 1), null, null)$$,
     ARRAY['%mmp%','%forbidden%','%not enabled%','%11050%']),
    (330, 'private_get_mmp_status',
     $$select deribit.private_get_mmp_status((select unnest(enum_range(null::deribit.private_get_mmp_status_request_index_name)) limit 1), null, null)$$,
     ARRAY['%mmp%','%forbidden%','%not enabled%','%11050%']),
    (340, 'private_set_mmp_config',
     $$select deribit.private_set_mmp_config((select unnest(enum_range(null::deribit.private_set_mmp_config_request_index_name)) limit 1), 10, 10, null, null, null, null, null, null, null)$$,
     ARRAY['%mmp%','%forbidden%','%not enabled%','%11050%']),
    (350, 'private_reset_mmp',
     $$select deribit.private_reset_mmp((select unnest(enum_range(null::deribit.private_reset_mmp_request_index_name)) limit 1), null, null)$$,
     ARRAY['%mmp%','%forbidden%','%not enabled%','%11050%']),

    (360, 'private_set_self_trading_config',
     $$select deribit.private_set_self_trading_config('reject_taker', false, false)$$,
     ARRAY['%tfa%','%forbidden%','%not allowed%','%13021%']),
    (370, 'private_change_margin_model',
     $$select deribit.private_change_margin_model('segregated_sm', null, true)$$,
     ARRAY['%tfa%','%forbidden%','%not allowed%','%13021%']),

    (380, 'private_enable_cancel_on_disconnect',
     $$select deribit.private_enable_cancel_on_disconnect('account')$$,
     ARRAY['%13021%']),
    (390, 'private_get_cancel_on_disconnect',
     $$select deribit.private_get_cancel_on_disconnect('account')$$,
     ARRAY[]::text[]),
    (400, 'private_disable_cancel_on_disconnect',
     $$select deribit.private_disable_cancel_on_disconnect('account')$$,
     ARRAY['%13021%']),

    (420, 'private_get_open_orders',
     $$select deribit.private_get_open_orders('future', null)$$,
     ARRAY[]::text[]),
    (430, 'private_get_open_orders_by_currency',
     $$select deribit.private_get_open_orders_by_currency(pg_temp.test_first_enum(null::deribit.private_get_open_orders_by_currency_request_currency), pg_temp.test_first_enum(null::deribit.private_get_open_orders_by_currency_request_kind), null)$$,
     ARRAY[]::text[]),
    (440, 'private_get_open_orders_by_instrument',
     $$select deribit.private_get_open_orders_by_instrument((select instrument_name from auth_ctx), null)$$,
     ARRAY[]::text[]),
    (450, 'private_get_open_orders_by_label',
     $$select deribit.private_get_open_orders_by_label(pg_temp.test_first_enum(null::deribit.private_get_open_orders_by_label_request_currency), (select label from order_ctx))$$,
     ARRAY[]::text[]),
    (460, 'private_get_order_state',
     $$select deribit.private_get_order_state((select order_id from order_ctx))$$,
     ARRAY[]::text[]),
    (470, 'private_get_order_state_by_label',
     $$select deribit.private_get_order_state_by_label(pg_temp.test_first_enum(null::deribit.private_get_order_state_by_label_request_currency), (select label from order_ctx))$$,
     ARRAY[]::text[]),
    (480, 'private_get_order_margin_by_ids',
     $$select deribit.private_get_order_margin_by_ids(ARRAY[(select order_id from order_ctx)]::text[])$$,
     ARRAY[]::text[]),
    (490, 'private_get_order_history_by_currency',
     $$select deribit.private_get_order_history_by_currency(pg_temp.test_first_enum(null::deribit.private_get_order_history_by_currency_request_currency), pg_temp.test_first_enum(null::deribit.private_get_order_history_by_currency_request_kind), 10, 0, true, true, false, null, false)$$,
     ARRAY[]::text[]),
    (500, 'private_get_order_history_by_instrument',
     $$select deribit.private_get_order_history_by_instrument((select instrument_name from auth_ctx), 10, 0, true, true, false, null, false)$$,
     ARRAY[]::text[]),

    (510, 'private_edit',
     $$select deribit.private_edit(order_id => (select order_id from order_ctx), price => 10001.0)$$,
     ARRAY['%order not found%','%invalid%','%-32000%']),
    (520, 'private_edit_by_label',
     $$select deribit.private_edit_by_label(instrument_name => (select instrument_name from auth_ctx), label => (select label from order_ctx), price => 10002.0)$$,
     ARRAY['%order not found%','%invalid%','%-32000%']),
    (530, 'private_cancel_by_label',
     $$select deribit.private_cancel_by_label((select label from order_ctx), pg_temp.test_first_enum(null::deribit.private_cancel_by_label_request_currency))$$,
     ARRAY['%not found%','%no_orders%']),
    (540, 'private_cancel',
     $$select deribit.private_cancel((select order_id from order_ctx))$$,
     ARRAY['%not found%','%11044%']),

    (550, 'private_cancel_all',
     $$select deribit.private_cancel_all(false, false)$$,
     ARRAY['%no_orders%']),
    (560, 'private_cancel_all_by_currency',
     $$select deribit.private_cancel_all_by_currency(pg_temp.test_first_enum(null::deribit.private_cancel_all_by_currency_request_currency), pg_temp.test_first_enum(null::deribit.private_cancel_all_by_currency_request_kind), null, false, false)$$,
     ARRAY['%no_orders%']),
    (570, 'private_cancel_all_by_currency_pair',
     $$select deribit.private_cancel_all_by_currency_pair(pg_temp.test_first_enum(null::deribit.private_cancel_all_by_currency_pair_request_currency_pair), pg_temp.test_first_enum(null::deribit.private_cancel_all_by_currency_pair_request_kind), null, false, false)$$,
     ARRAY['%no_orders%']),
    (580, 'private_cancel_all_by_instrument',
     $$select deribit.private_cancel_all_by_instrument((select instrument_name from auth_ctx), null, false, false, false)$$,
     ARRAY['%no_orders%']),
    (590, 'private_cancel_all_by_kind_or_type',
     $$select deribit.private_cancel_all_by_kind_or_type(ARRAY[(select currency from auth_ctx)]::text[], pg_temp.test_first_enum(null::deribit.private_cancel_all_by_kind_or_type_request_kind), null, false, false)$$,
     ARRAY['%no_orders%']),
    (600, 'private_cancel_quotes',
     $$select deribit.private_cancel_quotes(pg_temp.test_first_enum(null::deribit.private_cancel_quotes_request_cancel_type), pg_temp.test_first_enum(null::deribit.private_cancel_quotes_request_currency), pg_temp.test_first_enum(null::deribit.private_cancel_quotes_request_currency_pair), false, false, null, null, null, null, null)$$,
     ARRAY['%no_quotes%','%10004%']),
    (610, 'private_close_position',
     $$select deribit.private_close_position((select instrument_name from auth_ctx), 'market', null)$$,
     ARRAY['%no position%','%not found%','%10010%']),

    (620, 'private_get_user_trades_by_currency',
     $$select deribit.private_get_user_trades_by_currency(pg_temp.test_first_enum(null::deribit.private_get_user_trades_by_currency_request_currency), pg_temp.test_first_enum(null::deribit.private_get_user_trades_by_currency_request_kind), null, null, 10, (select start_ms from auth_ctx), (select now_ms from auth_ctx), pg_temp.test_first_enum(null::deribit.private_get_user_trades_by_currency_request_sorting), false, null)$$,
     ARRAY[]::text[]),
    (630, 'private_get_user_trades_by_currency_and_time',
     $$select deribit.private_get_user_trades_by_currency_and_time(pg_temp.test_first_enum(null::deribit.private_get_user_trades_by_currency_and_time_request_currency), (select start_ms from auth_ctx), (select now_ms from auth_ctx), pg_temp.test_first_enum(null::deribit.private_get_user_trades_by_currency_and_time_request_kind), 10, pg_temp.test_first_enum(null::deribit.private_get_user_trades_by_currency_and_time_request_sorting), false)$$,
     ARRAY[]::text[]),
    (640, 'private_get_user_trades_by_instrument',
     $$select deribit.private_get_user_trades_by_instrument((select instrument_name from auth_ctx), null, null, 10, (select start_ms from auth_ctx), (select now_ms from auth_ctx), false, 'desc')$$,
     ARRAY[]::text[]),
    (650, 'private_get_user_trades_by_instrument_and_time',
     $$select deribit.private_get_user_trades_by_instrument_and_time((select instrument_name from auth_ctx), (select start_ms from auth_ctx), (select now_ms from auth_ctx), 10, 'desc', false)$$,
     ARRAY[]::text[]),
    (660, 'private_get_user_trades_by_order',
     $$select deribit.private_get_user_trades_by_order((select order_id from order_ctx), 'desc', false)$$,
     ARRAY[]::text[]),
    (670, 'private_get_trigger_order_history',
     $$select deribit.private_get_trigger_order_history(pg_temp.test_first_enum(null::deribit.private_get_trigger_order_history_request_currency), (select instrument_name from auth_ctx), 10, null)$$,
     ARRAY[]::text[]),

    (700, 'private_list_api_keys',
     $$select deribit.private_list_api_keys()$$,
     ARRAY[]::text[]),
    (710, 'private_change_api_key_name',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_change_api_key_name((select api_key_id from api_key_ctx)::bigint, (select api_key_name from api_key_ctx) || '_a') end$$,
     ARRAY[]::text[]),
    (720, 'private_edit_api_key',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_edit_api_key((select api_key_id from api_key_ctx)::bigint, 'trade:read', (select api_key_name from api_key_ctx) || '_b', true, null, null) end$$,
     ARRAY[]::text[]),
    (730, 'private_change_scope_in_api_key',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_change_scope_in_api_key('trade:read', (select api_key_id from api_key_ctx)::bigint) end$$,
     ARRAY[]::text[]),
    (740, 'private_disable_api_key',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_disable_api_key((select api_key_id from api_key_ctx)::bigint) end$$,
     ARRAY[]::text[]),
    (750, 'private_enable_api_key',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_enable_api_key((select api_key_id from api_key_ctx)::bigint) end$$,
     ARRAY[]::text[]),
    (760, 'private_reset_api_key',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_reset_api_key((select api_key_id from api_key_ctx)::bigint) end$$,
     ARRAY[]::text[]),
    (770, 'private_remove_api_key',
     $$select case when (select api_key_id from api_key_ctx) is null then null else deribit.private_remove_api_key((select api_key_id from api_key_ctx)::bigint) end$$,
     ARRAY[]::text[]),

    (800, 'private_get_subaccounts',
     $$select deribit.private_get_subaccounts(true)$$,
     ARRAY[]::text[]),
    (810, 'private_get_subaccounts_details',
     $$select deribit.private_get_subaccounts_details(pg_temp.test_first_enum(null::deribit.private_get_subaccounts_details_request_currency), false)$$,
     ARRAY[]::text[]),
    (820, 'private_change_subaccount_name',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_change_subaccount_name((select subaccount_id from subaccount_ctx)::bigint, 'pgtap_sub_' || (select short_suffix from auth_ctx)) end$$,
     ARRAY[]::text[]),
    (830, 'private_set_email_for_subaccount',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_set_email_for_subaccount((select subaccount_id from subaccount_ctx)::bigint, 'pgtap+' || (select short_suffix from auth_ctx) || '@example.com') end$$,
     ARRAY[]::text[]),
    (840, 'private_toggle_subaccount_login',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_toggle_subaccount_login((select subaccount_id from subaccount_ctx)::bigint, pg_temp.test_first_enum(null::deribit.private_toggle_subaccount_login_request_state)) end$$,
     ARRAY[]::text[]),
    (850, 'private_toggle_notifications_from_subaccount',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_toggle_notifications_from_subaccount((select subaccount_id from subaccount_ctx)::bigint, true) end$$,
     ARRAY[]::text[]),
    (860, 'private_set_disabled_trading_products',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_set_disabled_trading_products((select subaccount_id from subaccount_ctx)::bigint, ARRAY[pg_temp.test_first_enum(null::deribit.private_set_disabled_trading_products_request_trading_products)]::deribit.private_set_disabled_trading_products_request_trading_products[]) end$$,
     ARRAY['%tfa%','%forbidden%','%not allowed%']),

    (870, 'private_submit_transfer_between_subaccounts',
     $$select case when (select subaccount_id from subaccount_ctx) is null or (select subaccount_id_2 from subaccount_ctx) is null then null else deribit.private_submit_transfer_between_subaccounts(pg_temp.test_first_enum(null::deribit.private_submit_transfer_between_subaccounts_request_currency), 0.001, (select subaccount_id_2 from subaccount_ctx)::bigint, (select subaccount_id from subaccount_ctx)::bigint) end$$,
     ARRAY['%insufficient%','%not enough%','%forbidden%']),
    (880, 'private_submit_transfer_to_subaccount',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_submit_transfer_to_subaccount(pg_temp.test_first_enum(null::deribit.private_submit_transfer_to_subaccount_request_currency), 0.001, (select subaccount_id from subaccount_ctx)::bigint) end$$,
     ARRAY['%insufficient%','%not enough%','%forbidden%']),
    (890, 'private_submit_transfer_to_user',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_submit_transfer_to_user(pg_temp.test_first_enum(null::deribit.private_submit_transfer_to_user_request_currency), 0.001, (select subaccount_id from subaccount_ctx)) end$$,
     ARRAY['%insufficient%','%not enough%','%forbidden%','%not found%']),
    (900, 'private_remove_subaccount',
     $$select case when (select subaccount_id from subaccount_ctx) is null then null else deribit.private_remove_subaccount((select subaccount_id from subaccount_ctx)::bigint) end$$,
     ARRAY['%cannot%','%not allowed%','%has open positions%']),

    (920, 'private_get_address_book',
     $$select deribit.private_get_address_book(pg_temp.test_first_enum(null::deribit.private_get_address_book_request_currency), pg_temp.test_first_enum(null::deribit.private_get_address_book_request_type))$$,
     ARRAY[]::text[]),
    (930, 'private_add_to_address_book',
     $$select deribit.private_add_to_address_book(pg_temp.test_first_enum(null::deribit.private_add_to_address_book_request_currency), pg_temp.test_first_enum(null::deribit.private_add_to_address_book_request_type), (select address from address_ctx), (select label from address_ctx), (select vasp_name from address_ctx), (select vasp_did from address_ctx), (select address from address_ctx), true, true, null, null, null, null, null::text[])$$,
     ARRAY['%invalid%','%address%','%beneficiary%','%compliance%','%13021%']),
    (940, 'private_update_in_address_book',
     $$select deribit.private_update_in_address_book(pg_temp.test_first_enum(null::deribit.private_update_in_address_book_request_currency), pg_temp.test_first_enum(null::deribit.private_update_in_address_book_request_type), (select address from address_ctx), (select vasp_name from address_ctx), (select vasp_did from address_ctx), (select address from address_ctx), true, true, (select label from address_ctx), null::text, null::text, null::text, null::text)$$,
     ARRAY['%invalid%','%address%','%not found%','%13021%']),
    (950, 'private_remove_from_address_book',
     $$select deribit.private_remove_from_address_book(pg_temp.test_first_enum(null::deribit.private_remove_from_address_book_request_currency), pg_temp.test_first_enum(null::deribit.private_remove_from_address_book_request_type), (select address from address_ctx))$$,
     ARRAY['%not found%','%address%','%13021%']),

    (960, 'private_list_address_beneficiaries',
     $$select deribit.private_list_address_beneficiaries(pg_temp.test_first_enum(null::deribit.private_list_address_beneficiaries_request_currency), null, null, null, null, null, null, null, null, null, null, null, null, null)$$,
     ARRAY[]::text[]),
    (970, 'private_get_address_beneficiary',
     $$select deribit.private_get_address_beneficiary(pg_temp.test_first_enum(null::deribit.private_get_address_beneficiary_request_currency), (select address from address_ctx), null)$$,
     ARRAY['%not found%','%invalid%','%11090%']),
    (980, 'private_save_address_beneficiary',
     $$select deribit.private_save_address_beneficiary(pg_temp.test_first_enum(null::deribit.private_save_address_beneficiary_request_currency), (select address from address_ctx), true, true, true, (select vasp_name from address_ctx), (select vasp_did from address_ctx), (select address from address_ctx), null, null, null, null, null)$$,
     ARRAY['%invalid%','%address%','%beneficiary%','%compliance%','%13021%']),
    (990, 'private_delete_address_beneficiary',
     $$select deribit.private_delete_address_beneficiary(pg_temp.test_first_enum(null::deribit.private_delete_address_beneficiary_request_currency), (select address from address_ctx), null)$$,
     ARRAY['%not found%','%invalid%','%13021%']),

    (1000, 'private_list_custody_accounts',
     $$select deribit.private_list_custody_accounts(pg_temp.test_first_enum(null::deribit.private_list_custody_accounts_request_currency))$$,
     ARRAY['%forbidden%','%not enabled%']),

    (1020, 'private_get_block_trade_requests',
     $$select deribit.private_get_block_trade_requests(null)$$,
     ARRAY['%13021%','%forbidden%']),
    (1030, 'private_get_block_trades',
     $$select deribit.private_get_block_trades(pg_temp.test_first_enum(null::deribit.private_get_block_trades_request_currency), 10, null, null, null, null)$$,
     ARRAY['%13021%','%forbidden%']),
    (1040, 'private_get_pending_block_trades',
     $$select deribit.private_get_pending_block_trades()$$,
     ARRAY['%13021%','%forbidden%']),
    (1050, 'private_get_block_trade',
     $$select deribit.private_get_block_trade('dummy')$$,
     ARRAY['%not found%','%13021%','%forbidden%','%invalid%']),
    (1060, 'private_simulate_block_trade',
     $$select deribit.private_simulate_block_trade('[]'::jsonb, pg_temp.test_first_enum(null::deribit.private_simulate_block_trade_request_role))$$,
     ARRAY['%13021%','%forbidden%','%invalid%']),
    (1070, 'private_verify_block_trade',
     $$select deribit.private_verify_block_trade((select now_ms from auth_ctx), '1', pg_temp.test_first_enum(null::deribit.private_verify_block_trade_request_role), '[]'::jsonb)$$,
     ARRAY['%13021%','%forbidden%','%invalid%']),
    (1080, 'private_execute_block_trade',
     $$select deribit.private_execute_block_trade((select now_ms from auth_ctx), '1', pg_temp.test_first_enum(null::deribit.private_execute_block_trade_request_role), '[]'::jsonb, 'signature')$$,
     ARRAY['%13021%','%forbidden%','%invalid%']),
    (1090, 'private_approve_block_trade',
     $$select deribit.private_approve_block_trade((select now_ms from auth_ctx), '1', pg_temp.test_first_enum(null::deribit.private_approve_block_trade_request_role))$$,
     ARRAY['%13021%','%forbidden%','%invalid%']),
    (1100, 'private_reject_block_trade',
     $$select deribit.private_reject_block_trade((select now_ms from auth_ctx), '1', pg_temp.test_first_enum(null::deribit.private_reject_block_trade_request_role))$$,
     ARRAY['%13021%','%forbidden%','%invalid%']),
    (1110, 'private_invalidate_block_trade_signature',
     $$select deribit.private_invalidate_block_trade_signature('signature')$$,
     ARRAY['%13021%','%forbidden%','%invalid%']),

    (1120, 'private_get_broker_trade_requests',
     $$select deribit.private_get_broker_trade_requests()$$,
     ARRAY['%13021%','%forbidden%']),
    (1130, 'private_get_broker_trades',
     $$select deribit.private_get_broker_trades(pg_temp.test_first_enum(null::deribit.private_get_broker_trades_request_currency), 10, null, null)$$,
     ARRAY['%13021%','%forbidden%']),

    (1140, 'private_create_combo',
     $$select deribit.private_create_combo('[]'::jsonb)$$,
     ARRAY['%invalid%','%forbidden%','%-32602%']),
    (1150, 'private_move_positions',
     $$select case when (select subaccount_id from subaccount_ctx) is null or (select subaccount_id_2 from subaccount_ctx) is null then null else deribit.private_move_positions((select subaccount_id from subaccount_ctx)::bigint, (select subaccount_id_2 from subaccount_ctx)::bigint, '[]'::jsonb, pg_temp.test_first_enum(null::deribit.private_move_positions_request_currency)) end$$,
     ARRAY['%invalid%','%forbidden%','%not found%']),

    (1160, 'private_enable_affiliate_program',
     $$select deribit.private_enable_affiliate_program()$$,
     ARRAY['%not eligible%','%forbidden%','%13021%']),
    (1170, 'private_get_affiliate_program_info',
     $$select deribit.private_get_affiliate_program_info()$$,
     ARRAY['%forbidden%']),

    (1180, 'private_cancel_transfer_by_id',
     $$select deribit.private_cancel_transfer_by_id(pg_temp.test_first_enum(null::deribit.private_cancel_transfer_by_id_request_currency), 0)$$,
     ARRAY['%not found%','%invalid%','%not allowed%','%13021%']),
    (1190, 'private_cancel_withdrawal',
     $$select deribit.private_cancel_withdrawal(pg_temp.test_first_enum(null::deribit.private_cancel_withdrawal_request_currency), 0)$$,
     ARRAY['%not found%','%invalid%','%not allowed%','%-32602%']),
    (1200, 'private_withdraw',
     $$select deribit.private_withdraw(pg_temp.test_first_enum(null::deribit.private_withdraw_request_currency), (select address from address_ctx), 0.001, pg_temp.test_first_enum(null::deribit.private_withdraw_request_priority))$$,
     ARRAY['%not supported%','%invalid%','%not allowed%','%insufficient%','%13021%']),

    (1210, 'private_logout',
     $$select deribit.private_logout(false)$$,
     ARRAY[]::text[]);

select plan((select count(*)::integer from endpoint_test_cases) + 4);

select ok(
    (select refresh_token is not null from token_ctx),
    'refresh token should be set'
);

select ok(
    (select order_id is not null from order_ctx),
    'order id should be set'
);

select ok(
    (select api_key_id is not null from api_key_ctx)
    or not (select can_manage_api_keys from api_key_ctx),
    'api key id should be set when scope permits'
);

select ok(
    (select subaccount_id is not null from subaccount_ctx)
    or not (select can_manage_subaccounts from subaccount_ctx),
    'subaccount id should be set when scope permits'
);

create temporary table endpoint_test_results(
    name text,
    ok boolean,
    note text
);

DO $$
DECLARE
    r record;
    pattern text;
    matched boolean;
BEGIN
    for r in select * from endpoint_test_cases order by seq loop
        begin
            execute r.sql;
            insert into endpoint_test_results values (r.name, true, 'ok');
        exception when others then
            matched := false;
            if r.allowed_errors is not null then
                foreach pattern in array r.allowed_errors loop
                    if sqlerrm like pattern then
                        matched := true;
                        exit;
                    end if;
                end loop;
            end if;

            if matched then
                insert into endpoint_test_results values (r.name, true, 'allowed error: ' || sqlerrm);
            else
                insert into endpoint_test_results values (r.name, false, sqlerrm);
            end if;
        end;
    end loop;
END $$;

select ok(ok, name || ' - ' || note)
from endpoint_test_results
order by name;

select * from finish();
rollback;
