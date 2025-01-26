create type deribit.auth as (
    client_id text,
    client_secret text,
    access_token text,
    refresh_token text
);
create type deribit.endpoint as enum (
    '/private/approve_block_trade',
    '/private/buy',
    '/private/cancel',
    '/private/cancel_all',
    '/private/cancel_all_by_currency',
    '/private/cancel_all_by_currency_pair',
    '/private/cancel_all_by_instrument',
    '/private/cancel_all_by_kind_or_type',
    '/private/cancel_by_label',
    '/private/cancel_quotes',
    '/private/cancel_transfer_by_id',
    '/private/cancel_withdrawal',
    '/private/change_api_key_name',
    '/private/change_margin_model',
    '/private/change_scope_in_api_key',
    '/private/change_subaccount_name',
    '/private/close_position',
    '/private/create_api_key',
    '/private/create_combo',
    '/private/create_deposit_address',
    '/private/create_subaccount',
    '/private/disable_api_key',
    '/private/disable_cancel_on_disconnect',
    '/private/edit',
    '/private/edit_api_key',
    '/private/edit_by_label',
    '/private/enable_affiliate_program',
    '/private/enable_api_key',
    '/private/enable_cancel_on_disconnect',
    '/private/execute_block_trade',
    '/private/get_access_log',
    '/private/get_account_summaries',
    '/private/get_account_summary',
    '/private/get_affiliate_program_info',
    '/private/get_block_trade',
    '/private/get_cancel_on_disconnect',
    '/private/get_current_deposit_address',
    '/private/get_deposits',
    '/private/get_email_language',
    '/private/get_last_block_trades_by_currency',
    '/private/get_margins',
    '/private/get_mmp_config',
    '/private/get_new_announcements',
    '/private/get_open_orders',
    '/private/get_open_orders_by_currency',
    '/private/get_open_orders_by_instrument',
    '/private/get_open_orders_by_label',
    '/private/get_order_history_by_currency',
    '/private/get_order_history_by_instrument',
    '/private/get_order_margin_by_ids',
    '/private/get_order_state',
    '/private/get_order_state_by_label',
    '/private/get_pending_block_trades',
    '/private/get_position',
    '/private/get_positions',
    '/private/get_settlement_history_by_currency',
    '/private/get_settlement_history_by_instrument',
    '/private/get_subaccounts',
    '/private/get_subaccounts_details',
    '/private/get_transaction_log',
    '/private/get_transfers',
    '/private/get_trigger_order_history',
    '/private/get_user_locks',
    '/private/get_user_trades_by_currency',
    '/private/get_user_trades_by_currency_and_time',
    '/private/get_user_trades_by_instrument',
    '/private/get_user_trades_by_instrument_and_time',
    '/private/get_user_trades_by_order',
    '/private/get_withdrawals',
    '/private/invalidate_block_trade_signature',
    '/private/list_api_keys',
    '/private/list_custody_accounts',
    '/private/logout',
    '/private/move_positions',
    '/private/pme/simulate',
    '/private/reject_block_trade',
    '/private/remove_api_key',
    '/private/remove_subaccount',
    '/private/reset_api_key',
    '/private/reset_mmp',
    '/private/sell',
    '/private/send_rfq',
    '/private/set_announcement_as_read',
    '/private/set_disabled_trading_products',
    '/private/set_email_for_subaccount',
    '/private/set_email_language',
    '/private/set_mmp_config',
    '/private/set_self_trading_config',
    '/private/simulate_block_trade',
    '/private/simulate_portfolio',
    '/private/submit_transfer_between_subaccounts',
    '/private/submit_transfer_to_subaccount',
    '/private/submit_transfer_to_user',
    '/private/toggle_notifications_from_subaccount',
    '/private/toggle_portfolio_margining',
    '/private/toggle_subaccount_login',
    '/private/verify_block_trade',
    '/private/withdraw',
    '/public/auth',
    '/public/exchange_token',
    '/public/fork_token',
    '/public/get_announcements',
    '/public/get_book_summary_by_currency',
    '/public/get_book_summary_by_instrument',
    '/public/get_combo_details',
    '/public/get_combo_ids',
    '/public/get_combos',
    '/public/get_contract_size',
    '/public/get_currencies',
    '/public/get_delivery_prices',
    '/public/get_funding_chart_data',
    '/public/get_funding_rate_history',
    '/public/get_funding_rate_value',
    '/public/get_historical_volatility',
    '/public/get_index_price',
    '/public/get_index_price_names',
    '/public/get_instrument',
    '/public/get_instruments',
    '/public/get_last_settlements_by_currency',
    '/public/get_last_settlements_by_instrument',
    '/public/get_last_trades_by_currency',
    '/public/get_last_trades_by_currency_and_time',
    '/public/get_last_trades_by_instrument',
    '/public/get_last_trades_by_instrument_and_time',
    '/public/get_mark_price_history',
    '/public/get_order_book',
    '/public/get_order_book_by_instrument_id',
    '/public/get_rfqs',
    '/public/get_supported_index_names',
    '/public/get_time',
    '/public/get_trade_volumes',
    '/public/get_tradingview_chart_data',
    '/public/get_volatility_index_data',
    '/public/status',
    '/public/test',
    '/public/ticker'
);
create type deribit.internal_error as (
    code int,
    message text,
    data json
);

create type deribit.internal_error_response as (
    usIn bigint,
    usOut bigint,
    usDiff int,
    jsonrpc text,
    testnet bool,
    error deribit.internal_error
);
create sequence deribit.internal_jsonrpc_identifier;

comment on sequence deribit.internal_jsonrpc_identifier is 'Internal sequence for deribit API JSON-RPC identifiers';
create table deribit.internal_archive (
    id bigint not null,
    created_at timestamptz not null default now(),
    url deribit.endpoint not null,
    request jsonb not null,
    response jsonb null
);

comment on table deribit.internal_archive is 'Internal archive of deribit API requests and responses';
create table deribit.internal_endpoint_rate_limit (
    key deribit.endpoint primary key,
    last_call timestamptz null default null,
    total_call_count bigint not null default 0,
    total_calls_rate_limited_count bigint not null default 0,
    total_rate_limiting_waiting interval not null default '0 seconds',
    min_rate_limiting_waiting interval not null default '0 seconds',
    max_rate_limiting_waiting interval not null default '0 seconds'
);

comment on table deribit.internal_endpoint_rate_limit is 'Internal rate limiting for deribit API endpoints';
create unlogged table deribit.matching_engine_request_call_log
(
    call_timestamp timestamp
);

alter table deribit.matching_engine_request_call_log set (
    autovacuum_vacuum_scale_factor = 0.05,
    autovacuum_vacuum_threshold = 50,
    autovacuum_analyze_scale_factor = 0.02,
    autovacuum_analyze_threshold = 50,
    autovacuum_vacuum_cost_delay = 10,
    autovacuum_vacuum_cost_limit = 2000
);

comment on table deribit.matching_engine_request_call_log is 'Internal log of deribit API requests';
create unlogged table deribit.non_matching_engine_request_call_log
(
    call_timestamp timestamp
);

alter table deribit.non_matching_engine_request_call_log set (
    autovacuum_vacuum_scale_factor = 0.05,
    autovacuum_vacuum_threshold = 50,
    autovacuum_analyze_scale_factor = 0.02,
    autovacuum_analyze_threshold = 50,
    autovacuum_vacuum_cost_delay = 10,
    autovacuum_vacuum_cost_limit = 2000
);

comment on table deribit.non_matching_engine_request_call_log is 'Internal log of deribit API requests';
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
create function deribit.enable_test_net()
returns void
language plpgsql
as
$$
begin
    execute format('set deribit.set_test_net = ''true''');
end
$$;

create function deribit.disable_test_net()
returns void
language plpgsql
as
$$
begin
    execute format('set deribit.set_test_net = ''false''');
end
$$;
create function deribit.internal_url_endpoint(url deribit.endpoint)
returns text
language sql
as $$
    select format('%s%s', base_url, end_point) as url
    from
    (
        select
            case 
                when current_setting('deribit.set_test_net', true) = 'true' then 'https://test.deribit.com/api/v2'
                else 'https://www.deribit.com/api/v2'
            end as base_url,
            url as end_point
    ) as a
$$;

comment on function deribit.internal_url_endpoint is 'Internal function to get deribit API endpoint URL';
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
create function deribit.matching_engine_request_log_call(url deribit.endpoint)
returns void
language plpgsql
as
$$
declare
    _call_count int;
    _rate_per_second int = 5;
    _delay float = 0;
    _has_delay int = 0;
    _cleanup interval = interval '2 seconds';
begin

    -- Insert the current timestamp into the temporary table
    insert into deribit.matching_engine_request_call_log(call_timestamp) values (clock_timestamp());

    -- Count the number of calls in the last second
    select count(*)
    into _call_count
    from deribit.matching_engine_request_call_log
    where call_timestamp > clock_timestamp() - interval '1 second';

    -- If the count exceeds the limit then wait for the remainder of the second
    if _call_count > _rate_per_second then
        _delay := 1 / _rate_per_second::float;
        _has_delay := 1;
        perform pg_sleep(_delay);
    end if;

    with delay_interval as (
        select make_interval(secs => _delay * _has_delay) as delay, make_interval(secs := 0) as zero_interval
    )
    update deribit.internal_endpoint_rate_limit
    set last_call = clock_timestamp(),
        total_call_count = total_call_count + 1,
        total_calls_rate_limited_count = total_calls_rate_limited_count + _has_delay,
        total_rate_limiting_waiting = total_rate_limiting_waiting + delay_interval.delay,
        min_rate_limiting_waiting = case when min_rate_limiting_waiting = delay_interval.zero_interval then delay_interval.delay else least(min_rate_limiting_waiting, delay_interval.delay) end,
        max_rate_limiting_waiting = greatest(max_rate_limiting_waiting, delay_interval.delay)
    from delay_interval
    where key = url;

    delete from deribit.matching_engine_request_call_log where call_timestamp < clock_timestamp() - _cleanup;

    return;
end;
$$;

comment on function deribit.matching_engine_request_log_call is 'Internal function for rate limiting deribit API requests to the matching engine';
create function deribit.non_matching_engine_request_log_call(url deribit.endpoint)
returns void
language plpgsql
as
$$
declare
    _call_count int;
    _rate_per_second int = 20;
    _delay float = 0;
    _has_delay int = 0;
    _cleanup interval = interval '2 seconds';
begin

    -- Insert the current timestamp into the temporary table
    insert into deribit.non_matching_engine_request_call_log(call_timestamp) values (clock_timestamp());

    -- Count the number of calls in the last second
    select count(*)
    into _call_count
    from deribit.non_matching_engine_request_call_log
    where call_timestamp > clock_timestamp() - interval '1 second';

    -- If the count exceeds the limit then wait for the remainder of the second
    if _call_count > _rate_per_second then
        _delay := 1 / _rate_per_second::float;
        _has_delay := 1;
        perform pg_sleep(_delay);
    end if;

    with delay_interval as (
        select make_interval(secs => _delay * _has_delay) as delay, make_interval(secs := 0) as zero_interval
    )
    update deribit.internal_endpoint_rate_limit
    set last_call = clock_timestamp(),
        total_call_count = total_call_count + 1,
        total_calls_rate_limited_count = total_calls_rate_limited_count + _has_delay,
        total_rate_limiting_waiting = total_rate_limiting_waiting + delay_interval.delay,
        min_rate_limiting_waiting = case when min_rate_limiting_waiting = delay_interval.zero_interval then delay_interval.delay else least(min_rate_limiting_waiting, delay_interval.delay) end,
        max_rate_limiting_waiting = greatest(max_rate_limiting_waiting, delay_interval.delay)
    from delay_interval
    where key = url;

    delete from deribit.non_matching_engine_request_call_log where call_timestamp < clock_timestamp() - _cleanup;

    return;
end;
$$;

comment on function deribit.non_matching_engine_request_log_call is 'Internal function for rate limiting deribit API requests to the non-matching endpoints';
create function deribit.private_build_auth_headers(auth deribit.auth)
returns omni_http.http_header
language sql
as $$
    select (
        'Authorization',
        case 
            when auth.client_id is not null then
                'Basic ' || encode(
                    (
                        format('%s:%s', auth.client_id, auth.client_secret)
                    )::bytea, 'base64'
                )
            else 
                'Bearer ' || auth.access_token
        end
    )::omni_http.http_header
    limit 1
$$;

comment on function deribit.private_build_auth_headers is 'Internal function to build deribit API authentication headers';
create function deribit.private_jsonrpc_request(
    auth deribit.auth,
    url deribit.endpoint,
    request anyelement,
    rate_limiter name
)
returns omni_httpc.http_response
language plpgsql
as $$
declare
    _http_request omni_httpc.http_request;
    _http_response omni_httpc.http_response;
	_error_response deribit.internal_error_response;
    _request_payload jsonb;
    _id bigint;
begin
    _id := nextval('deribit.internal_jsonrpc_identifier'::regclass);

    _request_payload := json_build_object(
        'method', url::text,
        'jsonrpc', '2.0',
        'params', jsonb_strip_nulls(to_jsonb(request)),
        'id', _id
    ) as payload;

    execute format('select %s (%L::deribit.endpoint);', rate_limiter, url);

    _http_request := omni_httpc.http_request(
            method := 'POST',
            url := deribit.internal_url_endpoint(url),
            body := _request_payload::text::bytea,
            headers := array[deribit.private_build_auth_headers(auth)]
    );

    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from omni_httpc.http_execute(_http_request) as response
    limit 1;

    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.internal_error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
             case
                when (_error_response.error).data is null then ''
                 else ':' || (_error_response.error).data
             end;
    end if;

    insert into deribit.internal_archive(id, url, request, response)
    values (_id, url, _request_payload, to_json(_http_response));

    return _http_response;

end;
$$;

comment on function deribit.private_jsonrpc_request is 'Internal function to send deribit API requests';
create function deribit.public_jsonrpc_request(
    url deribit.endpoint,
    request anyelement,
    rate_limiter name
)
returns omni_httpc.http_response
language plpgsql
as $$
declare
    _http_request omni_httpc.http_request;
    _http_response omni_httpc.http_response;
	_error_response deribit.internal_error_response;
    _request_payload jsonb;
    _id bigint;
begin
    _id := nextval('deribit.internal_jsonrpc_identifier'::regclass);

    _request_payload := json_build_object(
        'method', url::text,
        'jsonrpc', '2.0',
        'params', jsonb_strip_nulls(to_jsonb(request)),
        'id', _id
    ) as payload;

    execute format('select %s (%L::deribit.endpoint);', rate_limiter, url);

    _http_request := omni_httpc.http_request(
        method := 'POST',
        url := deribit.internal_url_endpoint(url),
        body := _request_payload::text::bytea
    );

    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from omni_httpc.http_execute(_http_request) as response
    limit 1;

    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.internal_error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
                case
                    when (_error_response.error).data is null then ''
                    else ':' || (_error_response.error).data
                end;
    end if;

    insert into deribit.internal_archive(id, url, request, response)
    values (_id, url, _request_payload, to_json(_http_response));

    return _http_response;

end;
$$;

comment on function deribit.public_jsonrpc_request is 'Internal function to send deribit API requests';
create function deribit.unnest_2d_1d(anyarray)
returns setof anyarray
language sql
immutable
parallel
safe
strict
as
$$
    select array_agg($1[d1][d2])
    from generate_subscripts($1, 1) d1,
        generate_subscripts($1, 2) d2
    group by d1
    order by d1
$$;

comment on function deribit.unnest_2d_1d(anyarray) is 'Unnest a 2d array into a 1d array. Useful for unnesting market data orderbook data with a 2d array of bids and asks.';
insert into deribit.internal_endpoint_rate_limit (key)
values
('/private/approve_block_trade'),
('/private/buy'),
('/private/cancel'),
('/private/cancel_all'),
('/private/cancel_all_by_currency'),
('/private/cancel_all_by_currency_pair'),
('/private/cancel_all_by_instrument'),
('/private/cancel_all_by_kind_or_type'),
('/private/cancel_by_label'),
('/private/cancel_quotes'),
('/private/cancel_transfer_by_id'),
('/private/cancel_withdrawal'),
('/private/change_api_key_name'),
('/private/change_margin_model'),
('/private/change_scope_in_api_key'),
('/private/change_subaccount_name'),
('/private/close_position'),
('/private/create_api_key'),
('/private/create_combo'),
('/private/create_deposit_address'),
('/private/create_subaccount'),
('/private/disable_api_key'),
('/private/disable_cancel_on_disconnect'),
('/private/edit'),
('/private/edit_api_key'),
('/private/edit_by_label'),
('/private/enable_affiliate_program'),
('/private/enable_api_key'),
('/private/enable_cancel_on_disconnect'),
('/private/execute_block_trade'),
('/private/get_access_log'),
('/private/get_account_summaries'),
('/private/get_account_summary'),
('/private/get_affiliate_program_info'),
('/private/get_block_trade'),
('/private/get_cancel_on_disconnect'),
('/private/get_current_deposit_address'),
('/private/get_deposits'),
('/private/get_email_language'),
('/private/get_last_block_trades_by_currency'),
('/private/get_margins'),
('/private/get_mmp_config'),
('/private/get_new_announcements'),
('/private/get_open_orders'),
('/private/get_open_orders_by_currency'),
('/private/get_open_orders_by_instrument'),
('/private/get_open_orders_by_label'),
('/private/get_order_history_by_currency'),
('/private/get_order_history_by_instrument'),
('/private/get_order_margin_by_ids'),
('/private/get_order_state'),
('/private/get_order_state_by_label'),
('/private/get_pending_block_trades'),
('/private/get_position'),
('/private/get_positions'),
('/private/get_settlement_history_by_currency'),
('/private/get_settlement_history_by_instrument'),
('/private/get_subaccounts'),
('/private/get_subaccounts_details'),
('/private/get_transaction_log'),
('/private/get_transfers'),
('/private/get_trigger_order_history'),
('/private/get_user_locks'),
('/private/get_user_trades_by_currency'),
('/private/get_user_trades_by_currency_and_time'),
('/private/get_user_trades_by_instrument'),
('/private/get_user_trades_by_instrument_and_time'),
('/private/get_user_trades_by_order'),
('/private/get_withdrawals'),
('/private/invalidate_block_trade_signature'),
('/private/list_api_keys'),
('/private/list_custody_accounts'),
('/private/logout'),
('/private/move_positions'),
('/private/pme/simulate'),
('/private/reject_block_trade'),
('/private/remove_api_key'),
('/private/remove_subaccount'),
('/private/reset_api_key'),
('/private/reset_mmp'),
('/private/sell'),
('/private/send_rfq'),
('/private/set_announcement_as_read'),
('/private/set_disabled_trading_products'),
('/private/set_email_for_subaccount'),
('/private/set_email_language'),
('/private/set_mmp_config'),
('/private/set_self_trading_config'),
('/private/simulate_block_trade'),
('/private/simulate_portfolio'),
('/private/submit_transfer_between_subaccounts'),
('/private/submit_transfer_to_subaccount'),
('/private/submit_transfer_to_user'),
('/private/toggle_notifications_from_subaccount'),
('/private/toggle_portfolio_margining'),
('/private/toggle_subaccount_login'),
('/private/verify_block_trade'),
('/private/withdraw'),
('/public/auth'),
('/public/exchange_token'),
('/public/fork_token'),
('/public/get_announcements'),
('/public/get_book_summary_by_currency'),
('/public/get_book_summary_by_instrument'),
('/public/get_combo_details'),
('/public/get_combo_ids'),
('/public/get_combos'),
('/public/get_contract_size'),
('/public/get_currencies'),
('/public/get_delivery_prices'),
('/public/get_funding_chart_data'),
('/public/get_funding_rate_history'),
('/public/get_funding_rate_value'),
('/public/get_historical_volatility'),
('/public/get_index_price'),
('/public/get_index_price_names'),
('/public/get_instrument'),
('/public/get_instruments'),
('/public/get_last_settlements_by_currency'),
('/public/get_last_settlements_by_instrument'),
('/public/get_last_trades_by_currency'),
('/public/get_last_trades_by_currency_and_time'),
('/public/get_last_trades_by_instrument'),
('/public/get_last_trades_by_instrument_and_time'),
('/public/get_mark_price_history'),
('/public/get_order_book'),
('/public/get_order_book_by_instrument_id'),
('/public/get_rfqs'),
('/public/get_supported_index_names'),
('/public/get_time'),
('/public/get_trade_volumes'),
('/public/get_tradingview_chart_data'),
('/public/get_volatility_index_data'),
('/public/status'),
('/public/test'),
('/public/ticker');
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_approve_block_trade_request_role as enum (
    'maker',
    'taker'
);

create type deribit.private_approve_block_trade_request as (
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_approve_block_trade_request_role
);

comment on column deribit.private_approve_block_trade_request."timestamp" is '(Required) Timestamp, shared with other party (milliseconds since the UNIX epoch)';
comment on column deribit.private_approve_block_trade_request."nonce" is '(Required) Nonce, shared with other party';
comment on column deribit.private_approve_block_trade_request."role" is '(Required) Describes if user wants to be maker or taker of trades';

create type deribit.private_approve_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_approve_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_approve_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_approve_block_trade_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_approve_block_trade(
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_approve_block_trade_request_role
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "timestamp",
            "nonce",
            "role"
        )::deribit.private_approve_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/approve_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_approve_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_approve_block_trade is 'Used to approve a pending block trade. nonce and timestamp are used to identify the block trade while role should be opposite to the trading counterparty. To use a block trade approval feature the additional API key setting feature called: enabled_features: block_trade_approval is required. This key has to be given to broker/registered partner who performs the trades on behalf of the user for the feature to be active. If the user wants to approve the trade, he has to approve it from different API key with doesn''t have this feature enabled.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_buy_request_otoco_config_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_buy_request_otoco_config_type as enum (
    'limit',
    'market',
    'market_limit',
    'stop_limit',
    'stop_market',
    'take_limit',
    'take_market',
    'trailing_stop'
);

create type deribit.private_buy_request_otoco_config_time_in_force as enum (
    'fill_or_kill',
    'good_til_cancelled',
    'good_til_day',
    'immediate_or_cancel'
);

create type deribit.private_buy_request_otoco_config_trigger as enum (
    'index_price',
    'last_price',
    'mark_price'
);

create type deribit.private_buy_request_type as enum (
    'limit',
    'market',
    'market_limit',
    'stop_limit',
    'stop_market',
    'take_limit',
    'take_market',
    'trailing_stop'
);

create type deribit.private_buy_request_time_in_force as enum (
    'fill_or_kill',
    'good_til_cancelled',
    'good_til_day',
    'immediate_or_cancel'
);

create type deribit.private_buy_request_trigger as enum (
    'index_price',
    'last_price',
    'mark_price'
);

create type deribit.private_buy_request_advanced as enum (
    'implv',
    'usd'
);

create type deribit.private_buy_request_linked_order_type as enum (
    'one_cancels_other',
    'one_triggers_one_cancels_other',
    'one_triggers_other'
);

create type deribit.private_buy_request_trigger_fill_condition as enum (
    'complete_fill',
    'first_hit',
    'incremental'
);

create type deribit.private_buy_request_otoco_config as (
    "amount" double precision,
    "direction" deribit.private_buy_request_otoco_config_direction,
    "type" deribit.private_buy_request_otoco_config_type,
    "label" text,
    "price" double precision,
    "reduce_only" boolean,
    "time_in_force" deribit.private_buy_request_otoco_config_time_in_force,
    "post_only" boolean,
    "reject_post_only" boolean,
    "trigger_price" double precision,
    "trigger_offset" double precision,
    "trigger" deribit.private_buy_request_otoco_config_trigger
);

comment on column deribit.private_buy_request_otoco_config."amount" is 'It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_buy_request_otoco_config."direction" is '(Required) Direction of trade from the maker perspective';
comment on column deribit.private_buy_request_otoco_config."type" is 'The order type, default: "limit"';
comment on column deribit.private_buy_request_otoco_config."label" is 'user defined label for the order (maximum 64 characters)';
comment on column deribit.private_buy_request_otoco_config."price" is 'The order price in base currency (Only for limit and stop_limit orders) When adding an order with advanced=usd, the field price should be the option price value in USD. When adding an order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_buy_request_otoco_config."reduce_only" is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_buy_request_otoco_config."time_in_force" is 'Specifies how long the order remains in effect. Default "good_til_cancelled" "good_til_cancelled" - unfilled order remains in order book until cancelled "good_til_day" - unfilled order remains in order book till the end of the trading session "fill_or_kill" - execute a transaction immediately and completely or not at all "immediate_or_cancel" - execute a transaction immediately, and any portion of the order that cannot be immediately filled is cancelled';
comment on column deribit.private_buy_request_otoco_config."post_only" is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just below or above the spread (according to the direction of the order). Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_buy_request_otoco_config."reject_post_only" is 'If an order is considered post-only and this field is set to true then the order is put to the order book unmodified or the request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_buy_request_otoco_config."trigger_price" is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_buy_request_otoco_config."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered';
comment on column deribit.private_buy_request_otoco_config."trigger" is 'Defines the trigger type. Required for "Stop-Loss", "Take-Profit" and "Trailing" trigger orders';

create type deribit.private_buy_request as (
    "instrument_name" text,
    "amount" double precision,
    "contracts" double precision,
    "type" deribit.private_buy_request_type,
    "label" text,
    "price" double precision,
    "time_in_force" deribit.private_buy_request_time_in_force,
    "max_show" double precision,
    "post_only" boolean,
    "reject_post_only" boolean,
    "reduce_only" boolean,
    "trigger_price" double precision,
    "trigger_offset" double precision,
    "trigger" deribit.private_buy_request_trigger,
    "advanced" deribit.private_buy_request_advanced,
    "mmp" boolean,
    "valid_until" bigint,
    "linked_order_type" deribit.private_buy_request_linked_order_type,
    "trigger_fill_condition" deribit.private_buy_request_trigger_fill_condition,
    "otoco_config" deribit.private_buy_request_otoco_config[]
);

comment on column deribit.private_buy_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_buy_request."amount" is 'It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is the underlying base currency coin. For options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH. The amount is a mandatory parameter if contracts parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_buy_request."contracts" is 'It represents the requested order size in contract units and can be passed instead of amount. The contracts is a mandatory parameter if amount parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_buy_request."type" is 'The order type, default: "limit"';
comment on column deribit.private_buy_request."label" is 'user defined label for the order (maximum 64 characters)';
comment on column deribit.private_buy_request."price" is 'The order price in base currency (Only for limit and stop_limit orders) When adding an order with advanced=usd, the field price should be the option price value in USD. When adding an order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_buy_request."time_in_force" is 'Specifies how long the order remains in effect. Default "good_til_cancelled" "good_til_cancelled" - unfilled order remains in order book until cancelled "good_til_day" - unfilled order remains in order book till the end of the trading session "fill_or_kill" - execute a transaction immediately and completely or not at all "immediate_or_cancel" - execute a transaction immediately, and any portion of the order that cannot be immediately filled is cancelled';
comment on column deribit.private_buy_request."max_show" is 'Maximum amount within an order to be shown to other customers, 0 for invisible order';
comment on column deribit.private_buy_request."post_only" is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just below the spread. Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_buy_request."reject_post_only" is 'If an order is considered post-only and this field is set to true then the order is put to the order book unmodified or the request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_buy_request."reduce_only" is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_buy_request."trigger_price" is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_buy_request."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered';
comment on column deribit.private_buy_request."trigger" is 'Defines the trigger type. Required for "Stop-Loss", "Take-Profit" and "Trailing" trigger orders';
comment on column deribit.private_buy_request."advanced" is 'Advanced option order type. (Only for options. Advanced USD orders are not supported for linear options.)';
comment on column deribit.private_buy_request."mmp" is 'Order MMP flag, only for order_type ''limit''';
comment on column deribit.private_buy_request."valid_until" is 'Timestamp, when provided server will start processing request in Matching Engine only before given timestamp, in other cases timed_out error will be responded. Remember that the given timestamp should be consistent with the server''s time, use /public/time method to obtain current server time.';
comment on column deribit.private_buy_request."linked_order_type" is 'The type of the linked order. "one_triggers_other" - Execution of primary order triggers the placement of one or more secondary orders. "one_cancels_other" - The execution of one order in a pair automatically cancels the other, typically used to set a stop-loss and take-profit simultaneously. "one_triggers_one_cancels_other" - The execution of a primary order triggers two secondary orders (a stop-loss and take-profit pair), where the execution of one secondary order cancels the other.';
comment on column deribit.private_buy_request."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_buy_request."otoco_config" is 'List of trades to create or cancel when this order is filled.';

create type deribit.private_buy_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_buy_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_buy_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_buy_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_buy_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_buy_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_buy_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_buy_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_buy_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_buy_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_buy_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_buy_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_buy_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_buy_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_buy_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_buy_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_buy_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_buy_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_buy_response_trade."matching_id" is 'Always null';
comment on column deribit.private_buy_response_trade."price" is 'Price in base currency';
comment on column deribit.private_buy_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_buy_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_buy_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_buy_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_buy_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_buy_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_buy_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_buy_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_buy_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_buy_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_buy_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_buy_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_buy_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_buy_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_buy_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_buy_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_buy_response_order as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_buy_response_order."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_buy_response_order."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_buy_response_order."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_buy_response_order."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_buy_response_order."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_buy_response_order."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_buy_response_order."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_buy_response_order."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_buy_response_order."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_buy_response_order."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_buy_response_order."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_buy_response_order."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_buy_response_order."api" is 'true if created with API';
comment on column deribit.private_buy_response_order."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_buy_response_order."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_buy_response_order."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_buy_response_order."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_buy_response_order."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_buy_response_order."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_buy_response_order."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_buy_response_order."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_buy_response_order."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_buy_response_order."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_buy_response_order."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_buy_response_order."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_buy_response_order."direction" is 'Direction: buy, or sell';
comment on column deribit.private_buy_response_order."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_buy_response_order."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_buy_response_order."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_buy_response_order."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_buy_response_order."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_buy_response_order."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_buy_response_order."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_buy_response_order."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_buy_response_order."post_only" is 'true for post-only orders only';
comment on column deribit.private_buy_response_order."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_buy_response_order."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_buy_response_order."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_buy_response_order."order_id" is 'Unique order identifier';
comment on column deribit.private_buy_response_order."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_buy_response_order."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_buy_response_order."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_buy_response_order."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_buy_response_order."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_buy_response_order."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_buy_response_order."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_buy_response_order."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_buy_response_order."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_buy_response_order."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_buy_response_order."average_price" is 'Average fill price of the order';
comment on column deribit.private_buy_response_order."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_buy_response_result as (
    "order" deribit.private_buy_response_order,
    "trades" deribit.private_buy_response_trade[]
);

create type deribit.private_buy_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_buy_response_result
);

comment on column deribit.private_buy_response."id" is 'The id that was sent in the request';
comment on column deribit.private_buy_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_buy(
    "instrument_name" text,
    "amount" double precision default null,
    "contracts" double precision default null,
    "type" deribit.private_buy_request_type default null,
    "label" text default null,
    "price" double precision default null,
    "time_in_force" deribit.private_buy_request_time_in_force default null,
    "max_show" double precision default null,
    "post_only" boolean default null,
    "reject_post_only" boolean default null,
    "reduce_only" boolean default null,
    "trigger_price" double precision default null,
    "trigger_offset" double precision default null,
    "trigger" deribit.private_buy_request_trigger default null,
    "advanced" deribit.private_buy_request_advanced default null,
    "mmp" boolean default null,
    "valid_until" bigint default null,
    "linked_order_type" deribit.private_buy_request_linked_order_type default null,
    "trigger_fill_condition" deribit.private_buy_request_trigger_fill_condition default null,
    "otoco_config" deribit.private_buy_request_otoco_config[] default null
)
returns deribit.private_buy_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "amount",
            "contracts",
            "type",
            "label",
            "price",
            "time_in_force",
            "max_show",
            "post_only",
            "reject_post_only",
            "reduce_only",
            "trigger_price",
            "trigger_offset",
            "trigger",
            "advanced",
            "mmp",
            "valid_until",
            "linked_order_type",
            "trigger_fill_condition",
            "otoco_config"
        )::deribit.private_buy_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/buy'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_buy_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_buy is 'Places a buy order for an instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_request as (
    "order_id" text
);

comment on column deribit.private_cancel_request."order_id" is '(Required) The order id';

create type deribit.private_cancel_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_cancel_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_cancel_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_cancel_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_cancel_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_cancel_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_cancel_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_cancel_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_cancel_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_cancel_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_cancel_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_cancel_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_cancel_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_cancel_response_result."api" is 'true if created with API';
comment on column deribit.private_cancel_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_cancel_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_cancel_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_cancel_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_cancel_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_cancel_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_cancel_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_cancel_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_cancel_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_cancel_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_cancel_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_cancel_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_cancel_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_cancel_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_cancel_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_cancel_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_cancel_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_cancel_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_cancel_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_cancel_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_cancel_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_cancel_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_cancel_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_cancel_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_cancel_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_cancel_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_cancel_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_cancel_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_cancel_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_cancel_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_cancel_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_cancel_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_cancel_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_cancel_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_cancel_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_cancel_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_cancel_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_cancel_response_result
);

comment on column deribit.private_cancel_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_cancel(
    "order_id" text
)
returns deribit.private_cancel_response_result
language sql
as $$
    
    with request as (
        select row(
            "order_id"
        )::deribit.private_cancel_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel is 'Cancel an order, specified by order id';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_all_request as (
    "detailed" boolean,
    "freeze_quotes" boolean
);

comment on column deribit.private_cancel_all_request."detailed" is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_request."freeze_quotes" is 'Whether or not to reject incoming quotes for 1 second after cancelling (false by default). Related to private/mass_quote request.';

create type deribit.private_cancel_all_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_all_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_response."result" is 'Total number of successfully cancelled orders';

create function deribit.private_cancel_all(
    "detailed" boolean default null,
    "freeze_quotes" boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "detailed",
            "freeze_quotes"
        )::deribit.private_cancel_all_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_all'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_all_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_all is 'This method cancels all users orders and trigger orders within all currencies and instrument kinds.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_all_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_cancel_all_by_currency_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_cancel_all_by_currency_request_type as enum (
    'all',
    'limit',
    'stop',
    'take',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_cancel_all_by_currency_request as (
    "currency" deribit.private_cancel_all_by_currency_request_currency,
    "kind" deribit.private_cancel_all_by_currency_request_kind,
    "type" deribit.private_cancel_all_by_currency_request_type,
    "detailed" boolean,
    "freeze_quotes" boolean
);

comment on column deribit.private_cancel_all_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_cancel_all_by_currency_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_all_by_currency_request."type" is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_currency_request."detailed" is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_by_currency_request."freeze_quotes" is 'Whether or not to reject incoming quotes for 1 second after cancelling (false by default). Related to private/mass_quote request.';

create type deribit.private_cancel_all_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_all_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_currency_response."result" is 'Total number of successfully cancelled orders';

create function deribit.private_cancel_all_by_currency(
    "currency" deribit.private_cancel_all_by_currency_request_currency,
    "kind" deribit.private_cancel_all_by_currency_request_kind default null,
    "type" deribit.private_cancel_all_by_currency_request_type default null,
    "detailed" boolean default null,
    "freeze_quotes" boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "type",
            "detailed",
            "freeze_quotes"
        )::deribit.private_cancel_all_by_currency_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_all_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_all_by_currency_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_all_by_currency is 'Cancels all orders by currency, optionally filtered by instrument kind and/or order type.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_all_by_currency_pair_request_currency_pair as enum (
    'ada_usd',
    'ada_usdc',
    'ada_usdt',
    'algo_usd',
    'algo_usdc',
    'algo_usdt',
    'avax_usd',
    'avax_usdc',
    'avax_usdt',
    'bch_usd',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usd',
    'doge_usdc',
    'doge_usdt',
    'dot_usd',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usd',
    'link_usdc',
    'link_usdt',
    'ltc_usd',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usd',
    'matic_usdc',
    'matic_usdt',
    'near_usd',
    'near_usdc',
    'near_usdt',
    'shib_usd',
    'shib_usdc',
    'shib_usdt',
    'sol_usd',
    'sol_usdc',
    'sol_usdt',
    'trx_usd',
    'trx_usdc',
    'trx_usdt',
    'uni_usd',
    'uni_usdc',
    'uni_usdt',
    'usdc_usd',
    'xrp_usd',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.private_cancel_all_by_currency_pair_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_cancel_all_by_currency_pair_request_type as enum (
    'all',
    'limit',
    'stop',
    'take',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_cancel_all_by_currency_pair_request as (
    "currency_pair" deribit.private_cancel_all_by_currency_pair_request_currency_pair,
    "kind" deribit.private_cancel_all_by_currency_pair_request_kind,
    "type" deribit.private_cancel_all_by_currency_pair_request_type,
    "detailed" boolean,
    "freeze_quotes" boolean
);

comment on column deribit.private_cancel_all_by_currency_pair_request."currency_pair" is '(Required) The currency pair symbol';
comment on column deribit.private_cancel_all_by_currency_pair_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_all_by_currency_pair_request."type" is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_currency_pair_request."detailed" is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_by_currency_pair_request."freeze_quotes" is 'Whether or not to reject incoming quotes for 1 second after cancelling (false by default). Related to private/mass_quote request.';

create type deribit.private_cancel_all_by_currency_pair_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_all_by_currency_pair_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_currency_pair_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_currency_pair_response."result" is 'Total number of successfully cancelled orders';

create function deribit.private_cancel_all_by_currency_pair(
    "currency_pair" deribit.private_cancel_all_by_currency_pair_request_currency_pair,
    "kind" deribit.private_cancel_all_by_currency_pair_request_kind default null,
    "type" deribit.private_cancel_all_by_currency_pair_request_type default null,
    "detailed" boolean default null,
    "freeze_quotes" boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "currency_pair",
            "kind",
            "type",
            "detailed",
            "freeze_quotes"
        )::deribit.private_cancel_all_by_currency_pair_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_all_by_currency_pair'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_all_by_currency_pair_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_all_by_currency_pair is 'Cancels all orders by currency pair, optionally filtered by instrument kind and/or order type.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_all_by_instrument_request_type as enum (
    'all',
    'limit',
    'stop',
    'take',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_cancel_all_by_instrument_request as (
    "instrument_name" text,
    "type" deribit.private_cancel_all_by_instrument_request_type,
    "detailed" boolean,
    "include_combos" boolean,
    "freeze_quotes" boolean
);

comment on column deribit.private_cancel_all_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_cancel_all_by_instrument_request."type" is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_instrument_request."detailed" is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_by_instrument_request."include_combos" is 'When set to true orders in combo instruments affecting a given position will also be cancelled. Default: false';
comment on column deribit.private_cancel_all_by_instrument_request."freeze_quotes" is 'Whether or not to reject incoming quotes for 1 second after cancelling (false by default). Related to private/mass_quote request.';

create type deribit.private_cancel_all_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_all_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_instrument_response."result" is 'Total number of successfully cancelled orders';

create function deribit.private_cancel_all_by_instrument(
    "instrument_name" text,
    "type" deribit.private_cancel_all_by_instrument_request_type default null,
    "detailed" boolean default null,
    "include_combos" boolean default null,
    "freeze_quotes" boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "type",
            "detailed",
            "include_combos",
            "freeze_quotes"
        )::deribit.private_cancel_all_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_all_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_all_by_instrument_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_all_by_instrument is 'Cancels all orders by instrument, optionally filtered by order type.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_all_by_kind_or_type_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_cancel_all_by_kind_or_type_request_type as enum (
    'all',
    'limit',
    'stop',
    'take',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_cancel_all_by_kind_or_type_request as (
    "currency" text[],
    "kind" deribit.private_cancel_all_by_kind_or_type_request_kind,
    "type" deribit.private_cancel_all_by_kind_or_type_request_type,
    "detailed" boolean,
    "freeze_quotes" boolean
);

comment on column deribit.private_cancel_all_by_kind_or_type_request."currency" is '(Required) The currency symbol, list of currency symbols or "any" for all';
comment on column deribit.private_cancel_all_by_kind_or_type_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_all_by_kind_or_type_request."type" is 'Order type - limit, stop, take, trigger_all or all, default - all';
comment on column deribit.private_cancel_all_by_kind_or_type_request."detailed" is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_all_by_kind_or_type_request."freeze_quotes" is 'Whether or not to reject incoming quotes for 1 second after cancelling (false by default). Related to private/mass_quote request.';

create type deribit.private_cancel_all_by_kind_or_type_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_all_by_kind_or_type_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_by_kind_or_type_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_by_kind_or_type_response."result" is 'Total number of successfully cancelled orders';

create function deribit.private_cancel_all_by_kind_or_type(
    "currency" text[],
    "kind" deribit.private_cancel_all_by_kind_or_type_request_kind default null,
    "type" deribit.private_cancel_all_by_kind_or_type_request_type default null,
    "detailed" boolean default null,
    "freeze_quotes" boolean default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "type",
            "detailed",
            "freeze_quotes"
        )::deribit.private_cancel_all_by_kind_or_type_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_all_by_kind_or_type'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_all_by_kind_or_type_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_all_by_kind_or_type is 'Cancels all orders in currency(currencies), optionally filtered by instrument kind and/or order type.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_by_label_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_cancel_by_label_request as (
    "label" text,
    "currency" deribit.private_cancel_by_label_request_currency
);

comment on column deribit.private_cancel_by_label_request."label" is '(Required) user defined label for the order (maximum 64 characters)';
comment on column deribit.private_cancel_by_label_request."currency" is 'The currency symbol';

create type deribit.private_cancel_by_label_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_by_label_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_by_label_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_by_label_response."result" is 'Total number of successfully cancelled orders';

create function deribit.private_cancel_by_label(
    "label" text,
    "currency" deribit.private_cancel_by_label_request_currency default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "label",
            "currency"
        )::deribit.private_cancel_by_label_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_by_label'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_by_label_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_by_label is 'Cancels orders by label. All user''s orders (trigger orders too), with a given label are canceled in all currencies or in one given currency (in this case currency queue is used) ';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_quotes_request_cancel_type as enum (
    'all',
    'currency',
    'currency_pair',
    'delta',
    'instrument',
    'instrument_kind',
    'quote_set_id'
);

create type deribit.private_cancel_quotes_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_cancel_quotes_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_cancel_quotes_request_currency_pair as enum (
    'ada_usd',
    'ada_usdc',
    'ada_usdt',
    'algo_usd',
    'algo_usdc',
    'algo_usdt',
    'avax_usd',
    'avax_usdc',
    'avax_usdt',
    'bch_usd',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usd',
    'doge_usdc',
    'doge_usdt',
    'dot_usd',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usd',
    'link_usdc',
    'link_usdt',
    'ltc_usd',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usd',
    'matic_usdc',
    'matic_usdt',
    'near_usd',
    'near_usdc',
    'near_usdt',
    'shib_usd',
    'shib_usdc',
    'shib_usdt',
    'sol_usd',
    'sol_usdc',
    'sol_usdt',
    'trx_usd',
    'trx_usdc',
    'trx_usdt',
    'uni_usd',
    'uni_usdc',
    'uni_usdt',
    'usdc_usd',
    'xrp_usd',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.private_cancel_quotes_request as (
    "detailed" boolean,
    "freeze_quotes" boolean,
    "cancel_type" deribit.private_cancel_quotes_request_cancel_type,
    "min_delta" double precision,
    "max_delta" double precision,
    "quote_set_id" text,
    "instrument_name" text,
    "kind" deribit.private_cancel_quotes_request_kind,
    "currency" deribit.private_cancel_quotes_request_currency,
    "currency_pair" deribit.private_cancel_quotes_request_currency_pair
);

comment on column deribit.private_cancel_quotes_request."detailed" is 'When detailed is set to true output format is changed. See description. Default: false';
comment on column deribit.private_cancel_quotes_request."freeze_quotes" is 'Whether or not to reject incoming quotes for 1 second after cancelling (false by default). Related to private/mass_quote request.';
comment on column deribit.private_cancel_quotes_request."cancel_type" is '(Required) Type of cancel criteria.';
comment on column deribit.private_cancel_quotes_request."min_delta" is 'Min delta to cancel by delta (for cancel_type: delta).';
comment on column deribit.private_cancel_quotes_request."max_delta" is 'Max delta to cancel by delta (for cancel_type: delta).';
comment on column deribit.private_cancel_quotes_request."quote_set_id" is 'Unique identifier for the Quote set.';
comment on column deribit.private_cancel_quotes_request."instrument_name" is 'Instrument name.';
comment on column deribit.private_cancel_quotes_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_cancel_quotes_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_cancel_quotes_request."currency_pair" is '(Required) The currency pair symbol';

create type deribit.private_cancel_quotes_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.private_cancel_quotes_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_quotes_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_quotes_response."result" is 'Total number of successfully cancelled quotes';

create function deribit.private_cancel_quotes(
    "cancel_type" deribit.private_cancel_quotes_request_cancel_type,
    "currency" deribit.private_cancel_quotes_request_currency,
    "currency_pair" deribit.private_cancel_quotes_request_currency_pair,
    "detailed" boolean default null,
    "freeze_quotes" boolean default null,
    "min_delta" double precision default null,
    "max_delta" double precision default null,
    "quote_set_id" text default null,
    "instrument_name" text default null,
    "kind" deribit.private_cancel_quotes_request_kind default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "detailed",
            "freeze_quotes",
            "cancel_type",
            "min_delta",
            "max_delta",
            "quote_set_id",
            "instrument_name",
            "kind",
            "currency",
            "currency_pair"
        )::deribit.private_cancel_quotes_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_quotes'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_quotes_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_quotes is 'Cancels quotes based on the provided type. delta cancels quotes within a Delta range defined by min_delta and max_delta. quote_set_id cancels quotes by a specific Quote Set identifier. instrument cancels all quotes associated with a particular instrument. kind cancels all quotes for a certain instrument kind. currency cancels all quotes in a specified currency. currency_pair cancels all quotes in a specified currency pair. all cancels all quotes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_transfer_by_id_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_cancel_transfer_by_id_request as (
    "currency" deribit.private_cancel_transfer_by_id_request_currency,
    "id" bigint
);

comment on column deribit.private_cancel_transfer_by_id_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_cancel_transfer_by_id_request."id" is '(Required) Id of transfer';

create type deribit.private_cancel_transfer_by_id_response_result as (
    "amount" double precision,
    "created_timestamp" bigint,
    "currency" text,
    "direction" text,
    "id" bigint,
    "other_side" text,
    "state" text,
    "type" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_cancel_transfer_by_id_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_cancel_transfer_by_id_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_transfer_by_id_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_cancel_transfer_by_id_response_result."direction" is 'Transfer direction';
comment on column deribit.private_cancel_transfer_by_id_response_result."id" is 'Id of transfer';
comment on column deribit.private_cancel_transfer_by_id_response_result."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_cancel_transfer_by_id_response_result."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_cancel_transfer_by_id_response_result."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_cancel_transfer_by_id_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_cancel_transfer_by_id_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_cancel_transfer_by_id_response_result
);

comment on column deribit.private_cancel_transfer_by_id_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_transfer_by_id_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_cancel_transfer_by_id(
    "currency" deribit.private_cancel_transfer_by_id_request_currency,
    "id" bigint
)
returns deribit.private_cancel_transfer_by_id_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "id"
        )::deribit.private_cancel_transfer_by_id_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_transfer_by_id'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_transfer_by_id_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_transfer_by_id is 'Cancel transfer';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_cancel_withdrawal_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_cancel_withdrawal_request as (
    "currency" deribit.private_cancel_withdrawal_request_currency,
    "id" double precision
);

comment on column deribit.private_cancel_withdrawal_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_cancel_withdrawal_request."id" is '(Required) The withdrawal id';

create type deribit.private_cancel_withdrawal_response_result as (
    "address" text,
    "amount" double precision,
    "confirmed_timestamp" bigint,
    "created_timestamp" bigint,
    "currency" text,
    "fee" double precision,
    "id" bigint,
    "priority" double precision,
    "state" text,
    "transaction_id" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_cancel_withdrawal_response_result."address" is 'Address in proper format for currency';
comment on column deribit.private_cancel_withdrawal_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_cancel_withdrawal_response_result."confirmed_timestamp" is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_cancel_withdrawal_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_cancel_withdrawal_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_cancel_withdrawal_response_result."fee" is 'Fee in currency';
comment on column deribit.private_cancel_withdrawal_response_result."id" is 'Withdrawal id in Deribit system';
comment on column deribit.private_cancel_withdrawal_response_result."priority" is 'Id of priority level';
comment on column deribit.private_cancel_withdrawal_response_result."state" is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_cancel_withdrawal_response_result."transaction_id" is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_cancel_withdrawal_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_cancel_withdrawal_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_cancel_withdrawal_response_result
);

comment on column deribit.private_cancel_withdrawal_response."id" is 'The id that was sent in the request';
comment on column deribit.private_cancel_withdrawal_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_cancel_withdrawal(
    "currency" deribit.private_cancel_withdrawal_request_currency,
    "id" double precision
)
returns deribit.private_cancel_withdrawal_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "id"
        )::deribit.private_cancel_withdrawal_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/cancel_withdrawal'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_cancel_withdrawal_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_cancel_withdrawal is 'Cancels withdrawal request';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_change_api_key_name_request as (
    "id" bigint,
    "name" text
);

comment on column deribit.private_change_api_key_name_request."id" is '(Required) Id of key';
comment on column deribit.private_change_api_key_name_request."name" is '(Required) Name of key (only letters, numbers and underscores allowed; maximum length - 16 characters)';

create type deribit.private_change_api_key_name_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_change_api_key_name_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_change_api_key_name_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_change_api_key_name_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_change_api_key_name_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_change_api_key_name_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_change_api_key_name_response_result."id" is 'key identifier';
comment on column deribit.private_change_api_key_name_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_change_api_key_name_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_change_api_key_name_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_change_api_key_name_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_change_api_key_name_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_change_api_key_name_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_change_api_key_name_response_result
);

comment on column deribit.private_change_api_key_name_response."id" is 'The id that was sent in the request';
comment on column deribit.private_change_api_key_name_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_change_api_key_name(
    "id" bigint,
    "name" text
)
returns deribit.private_change_api_key_name_response_result
language sql
as $$
    
    with request as (
        select row(
            "id",
            "name"
        )::deribit.private_change_api_key_name_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/change_api_key_name'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_change_api_key_name_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_change_api_key_name is 'Changes name for key with given id. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_change_margin_model_request_margin_model as enum (
    'cross_pm',
    'cross_sm',
    'segregated_pm',
    'segregated_sm'
);

create type deribit.private_change_margin_model_request as (
    "user_id" bigint,
    "margin_model" deribit.private_change_margin_model_request_margin_model,
    "dry_run" boolean
);

comment on column deribit.private_change_margin_model_request."user_id" is 'Id of a (sub)account - by default current user id is used';
comment on column deribit.private_change_margin_model_request."margin_model" is '(Required) Margin model';
comment on column deribit.private_change_margin_model_request."dry_run" is 'If true request returns the result without switching the margining model. Default: false';

create type deribit.private_change_margin_model_response_old_state as (
    "available_balance" double precision,
    "initial_margin_rate" double precision,
    "maintenance_margin_rate" double precision
);

comment on column deribit.private_change_margin_model_response_old_state."available_balance" is 'Available balance before change';
comment on column deribit.private_change_margin_model_response_old_state."initial_margin_rate" is 'Initial margin rate before change';
comment on column deribit.private_change_margin_model_response_old_state."maintenance_margin_rate" is 'Maintenance margin rate before change';

create type deribit.private_change_margin_model_response_new_state as (
    "available_balance" double precision,
    "initial_margin_rate" double precision,
    "maintenance_margin_rate" double precision
);

comment on column deribit.private_change_margin_model_response_new_state."available_balance" is 'Available balance after change';
comment on column deribit.private_change_margin_model_response_new_state."initial_margin_rate" is 'Initial margin rate after change';
comment on column deribit.private_change_margin_model_response_new_state."maintenance_margin_rate" is 'Maintenance margin rate after change';

create type deribit.private_change_margin_model_response_result as (
    "currency" text,
    "new_state" deribit.private_change_margin_model_response_new_state,
    "old_state" deribit.private_change_margin_model_response_old_state
);

comment on column deribit.private_change_margin_model_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_change_margin_model_response_result."new_state" is 'Represents portfolio state after change';
comment on column deribit.private_change_margin_model_response_result."old_state" is 'Represents portfolio state before change';

create type deribit.private_change_margin_model_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_change_margin_model_response_result[]
);

comment on column deribit.private_change_margin_model_response."id" is 'The id that was sent in the request';
comment on column deribit.private_change_margin_model_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_change_margin_model(
    "margin_model" deribit.private_change_margin_model_request_margin_model,
    "user_id" bigint default null,
    "dry_run" boolean default null
)
returns setof deribit.private_change_margin_model_response_result
language sql
as $$
    
    with request as (
        select row(
            "user_id",
            "margin_model",
            "dry_run"
        )::deribit.private_change_margin_model_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/change_margin_model'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_change_margin_model_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."currency"::text,
        (b)."new_state"::deribit.private_change_margin_model_response_new_state,
        (b)."old_state"::deribit.private_change_margin_model_response_old_state
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_change_margin_model is 'Change margin model';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_change_scope_in_api_key_request as (
    "max_scope" text,
    "id" bigint
);

comment on column deribit.private_change_scope_in_api_key_request."max_scope" is '(Required) Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_change_scope_in_api_key_request."id" is '(Required) Id of key';

create type deribit.private_change_scope_in_api_key_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_change_scope_in_api_key_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_change_scope_in_api_key_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_change_scope_in_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_change_scope_in_api_key_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_change_scope_in_api_key_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_change_scope_in_api_key_response_result."id" is 'key identifier';
comment on column deribit.private_change_scope_in_api_key_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_change_scope_in_api_key_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_change_scope_in_api_key_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_change_scope_in_api_key_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_change_scope_in_api_key_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_change_scope_in_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_change_scope_in_api_key_response_result
);

comment on column deribit.private_change_scope_in_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_change_scope_in_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_change_scope_in_api_key(
    "max_scope" text,
    "id" bigint
)
returns deribit.private_change_scope_in_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
            "max_scope",
            "id"
        )::deribit.private_change_scope_in_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/change_scope_in_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_change_scope_in_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_change_scope_in_api_key is 'Changes scope for key with given id. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_change_subaccount_name_request as (
    "sid" bigint,
    "name" text
);

comment on column deribit.private_change_subaccount_name_request."sid" is '(Required) The user id for the subaccount';
comment on column deribit.private_change_subaccount_name_request."name" is '(Required) The new user name';

create type deribit.private_change_subaccount_name_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_change_subaccount_name_response."id" is 'The id that was sent in the request';
comment on column deribit.private_change_subaccount_name_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_change_subaccount_name_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_change_subaccount_name(
    "sid" bigint,
    "name" text
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "sid",
            "name"
        )::deribit.private_change_subaccount_name_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/change_subaccount_name'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_change_subaccount_name_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_change_subaccount_name is 'Change the user name for a subaccount';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_close_position_request_type as enum (
    'limit',
    'market'
);

create type deribit.private_close_position_request as (
    "instrument_name" text,
    "type" deribit.private_close_position_request_type,
    "price" double precision
);

comment on column deribit.private_close_position_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_close_position_request."type" is '(Required) The order type';
comment on column deribit.private_close_position_request."price" is 'Optional price for limit order.';

create type deribit.private_close_position_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_close_position_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_close_position_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_close_position_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_close_position_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_close_position_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_close_position_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_close_position_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_close_position_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_close_position_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_close_position_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_close_position_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_close_position_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_close_position_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_close_position_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_close_position_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_close_position_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_close_position_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_close_position_response_trade."matching_id" is 'Always null';
comment on column deribit.private_close_position_response_trade."price" is 'Price in base currency';
comment on column deribit.private_close_position_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_close_position_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_close_position_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_close_position_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_close_position_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_close_position_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_close_position_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_close_position_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_close_position_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_close_position_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_close_position_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_close_position_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_close_position_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_close_position_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_close_position_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_close_position_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_close_position_response_order as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_close_position_response_order."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_close_position_response_order."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_close_position_response_order."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_close_position_response_order."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_close_position_response_order."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_close_position_response_order."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_close_position_response_order."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_close_position_response_order."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_close_position_response_order."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_close_position_response_order."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_close_position_response_order."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_close_position_response_order."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_close_position_response_order."api" is 'true if created with API';
comment on column deribit.private_close_position_response_order."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_close_position_response_order."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_close_position_response_order."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_close_position_response_order."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_close_position_response_order."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_close_position_response_order."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_close_position_response_order."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_close_position_response_order."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_close_position_response_order."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_close_position_response_order."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_close_position_response_order."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_close_position_response_order."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_close_position_response_order."direction" is 'Direction: buy, or sell';
comment on column deribit.private_close_position_response_order."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_close_position_response_order."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_close_position_response_order."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_close_position_response_order."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_close_position_response_order."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_close_position_response_order."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_close_position_response_order."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_close_position_response_order."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_close_position_response_order."post_only" is 'true for post-only orders only';
comment on column deribit.private_close_position_response_order."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_close_position_response_order."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_close_position_response_order."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_close_position_response_order."order_id" is 'Unique order identifier';
comment on column deribit.private_close_position_response_order."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_close_position_response_order."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_close_position_response_order."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_close_position_response_order."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_close_position_response_order."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_close_position_response_order."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_close_position_response_order."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_close_position_response_order."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_close_position_response_order."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_close_position_response_order."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_close_position_response_order."average_price" is 'Average fill price of the order';
comment on column deribit.private_close_position_response_order."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_close_position_response_result as (
    "order" deribit.private_close_position_response_order,
    "trades" deribit.private_close_position_response_trade[]
);

create type deribit.private_close_position_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_close_position_response_result
);

comment on column deribit.private_close_position_response."id" is 'The id that was sent in the request';
comment on column deribit.private_close_position_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_close_position(
    "instrument_name" text,
    "type" deribit.private_close_position_request_type,
    "price" double precision default null
)
returns deribit.private_close_position_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "type",
            "price"
        )::deribit.private_close_position_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/close_position'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_close_position_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_close_position is 'Makes closing position reduce only order .';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_create_api_key_request as (
    "max_scope" text,
    "name" text,
    "public_key" text,
    "enabled_features" text[]
);

comment on column deribit.private_create_api_key_request."max_scope" is '(Required) Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_create_api_key_request."name" is 'Name of key (only letters, numbers and underscores allowed; maximum length - 16 characters)';
comment on column deribit.private_create_api_key_request."public_key" is 'ED25519 or RSA PEM Encoded public key that should be used to create asymmetric API Key for signing requests/authentication requests with user''s private key.';
comment on column deribit.private_create_api_key_request."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';

create type deribit.private_create_api_key_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_create_api_key_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_create_api_key_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_create_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_create_api_key_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_create_api_key_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_create_api_key_response_result."id" is 'key identifier';
comment on column deribit.private_create_api_key_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_create_api_key_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_create_api_key_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_create_api_key_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_create_api_key_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_create_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_create_api_key_response_result
);

comment on column deribit.private_create_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_create_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_create_api_key(
    "max_scope" text,
    "name" text default null,
    "public_key" text default null,
    "enabled_features" text[] default null
)
returns deribit.private_create_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
            "max_scope",
            "name",
            "public_key",
            "enabled_features"
        )::deribit.private_create_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/create_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_create_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_create_api_key is 'Creates a new api key with a given scope. Important notes';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_create_combo_request_trade_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_create_combo_request_trade as (
    "instrument_name" text,
    "amount" double precision,
    "direction" deribit.private_create_combo_request_trade_direction
);

comment on column deribit.private_create_combo_request_trade."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_create_combo_request_trade."amount" is 'It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_create_combo_request_trade."direction" is '(Required) Direction of trade from the maker perspective';

create type deribit.private_create_combo_request as (
    "trades" deribit.private_create_combo_request_trade[]
);

comment on column deribit.private_create_combo_request."trades" is '(Required) List of trades used to create a combo';

create type deribit.private_create_combo_response_leg as (
    "amount" bigint,
    "instrument_name" text
);

comment on column deribit.private_create_combo_response_leg."amount" is 'Size multiplier of a leg. A negative value indicates that the trades on given leg are in opposite direction to the combo trades they originate from';
comment on column deribit.private_create_combo_response_leg."instrument_name" is 'Unique instrument identifier';

create type deribit.private_create_combo_response_result as (
    "creation_timestamp" bigint,
    "id" text,
    "instrument_id" bigint,
    "legs" deribit.private_create_combo_response_leg[],
    "state" text,
    "state_timestamp" bigint
);

comment on column deribit.private_create_combo_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_create_combo_response_result."id" is 'Unique combo identifier';
comment on column deribit.private_create_combo_response_result."instrument_id" is 'Instrument ID';
comment on column deribit.private_create_combo_response_result."state" is 'Combo state: "rfq", "active", "inactive"';
comment on column deribit.private_create_combo_response_result."state_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_create_combo_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_create_combo_response_result
);

comment on column deribit.private_create_combo_response."id" is 'The id that was sent in the request';
comment on column deribit.private_create_combo_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_create_combo(
    "trades" deribit.private_create_combo_request_trade[]
)
returns deribit.private_create_combo_response_result
language sql
as $$
    
    with request as (
        select row(
            "trades"
        )::deribit.private_create_combo_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/create_combo'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_create_combo_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_create_combo is 'Verifies and creates a combo book or returns an existing combo matching given trades';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_create_deposit_address_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_create_deposit_address_request as (
    "currency" deribit.private_create_deposit_address_request_currency
);

comment on column deribit.private_create_deposit_address_request."currency" is '(Required) The currency symbol';

create type deribit.private_create_deposit_address_response_result as (
    "address" text,
    "creation_timestamp" bigint,
    "currency" text,
    "type" text
);

comment on column deribit.private_create_deposit_address_response_result."address" is 'Address in proper format for currency';
comment on column deribit.private_create_deposit_address_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_create_deposit_address_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_create_deposit_address_response_result."type" is 'Address type/purpose, allowed values : deposit, withdrawal, transfer';

create type deribit.private_create_deposit_address_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_create_deposit_address_response_result
);

comment on column deribit.private_create_deposit_address_response."id" is 'The id that was sent in the request';
comment on column deribit.private_create_deposit_address_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_create_deposit_address_response."result" is 'Object if address is created, null otherwise';

create function deribit.private_create_deposit_address(
    "currency" deribit.private_create_deposit_address_request_currency
)
returns deribit.private_create_deposit_address_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.private_create_deposit_address_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/create_deposit_address'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_create_deposit_address_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_create_deposit_address is 'Creates deposit address in currency';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_create_subaccount_response_eth as (
    "additional_reserve" double precision,
    "available_funds" double precision,
    "available_withdrawal_funds" double precision,
    "balance" double precision,
    "currency" text,
    "equity" double precision,
    "initial_margin" double precision,
    "maintenance_margin" double precision,
    "margin_balance" double precision,
    "spot_reserve" double precision
);

comment on column deribit.private_create_subaccount_response_eth."additional_reserve" is 'The account''s balance reserved in other orders';

create type deribit.private_create_subaccount_response_btc as (
    "additional_reserve" double precision,
    "available_funds" double precision,
    "available_withdrawal_funds" double precision,
    "balance" double precision,
    "currency" text,
    "equity" double precision,
    "initial_margin" double precision,
    "maintenance_margin" double precision,
    "margin_balance" double precision,
    "spot_reserve" double precision
);

comment on column deribit.private_create_subaccount_response_btc."additional_reserve" is 'The account''s balance reserved in other orders';

create type deribit.private_create_subaccount_response_portfolio as (
    "btc" deribit.private_create_subaccount_response_btc,
    "eth" deribit.private_create_subaccount_response_eth,
    "receive_notifications" boolean,
    "security_keys_enabled" boolean,
    "system_name" text,
    "type" text,
    "username" text
);

comment on column deribit.private_create_subaccount_response_portfolio."receive_notifications" is 'When true - receive all notification emails on the main email';
comment on column deribit.private_create_subaccount_response_portfolio."security_keys_enabled" is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_create_subaccount_response_portfolio."system_name" is 'System generated user nickname';
comment on column deribit.private_create_subaccount_response_portfolio."type" is 'Account type';
comment on column deribit.private_create_subaccount_response_portfolio."username" is 'Account name (given by user)';

create type deribit.private_create_subaccount_response_result as (
    "email" text,
    "id" bigint,
    "is_password" boolean,
    "login_enabled" boolean,
    "portfolio" deribit.private_create_subaccount_response_portfolio
);

comment on column deribit.private_create_subaccount_response_result."email" is 'User email';
comment on column deribit.private_create_subaccount_response_result."id" is 'Subaccount identifier';
comment on column deribit.private_create_subaccount_response_result."is_password" is 'true when password for the subaccount has been configured';
comment on column deribit.private_create_subaccount_response_result."login_enabled" is 'Informs whether login to the subaccount is enabled';

create type deribit.private_create_subaccount_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_create_subaccount_response_result
);

comment on column deribit.private_create_subaccount_response."id" is 'The id that was sent in the request';
comment on column deribit.private_create_subaccount_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_create_subaccount()
returns deribit.private_create_subaccount_response_result
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/create_subaccount'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.private_create_subaccount_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_create_subaccount is 'Create a new subaccount';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_disable_api_key_request as (
    "id" bigint
);

comment on column deribit.private_disable_api_key_request."id" is '(Required) Id of key';

create type deribit.private_disable_api_key_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_disable_api_key_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_disable_api_key_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_disable_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_disable_api_key_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_disable_api_key_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_disable_api_key_response_result."id" is 'key identifier';
comment on column deribit.private_disable_api_key_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_disable_api_key_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_disable_api_key_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_disable_api_key_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_disable_api_key_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_disable_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_disable_api_key_response_result
);

comment on column deribit.private_disable_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_disable_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_disable_api_key(
    "id" bigint
)
returns deribit.private_disable_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
            "id"
        )::deribit.private_disable_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/disable_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_disable_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_disable_api_key is 'Disables api key with given id. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_disable_cancel_on_disconnect_request_scope as enum (
    'account',
    'connection'
);

create type deribit.private_disable_cancel_on_disconnect_request as (
    "scope" deribit.private_disable_cancel_on_disconnect_request_scope
);

comment on column deribit.private_disable_cancel_on_disconnect_request."scope" is 'Specifies if Cancel On Disconnect change should be applied/checked for the current connection or the account (default - connection)  NOTICE: Scope connection can be used only when working via Websocket.';

create type deribit.private_disable_cancel_on_disconnect_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_disable_cancel_on_disconnect_response."id" is 'The id that was sent in the request';
comment on column deribit.private_disable_cancel_on_disconnect_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_disable_cancel_on_disconnect_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_disable_cancel_on_disconnect(
    "scope" deribit.private_disable_cancel_on_disconnect_request_scope default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "scope"
        )::deribit.private_disable_cancel_on_disconnect_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/disable_cancel_on_disconnect'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_disable_cancel_on_disconnect_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_disable_cancel_on_disconnect is 'Disable Cancel On Disconnect for the connection. When change is applied for the account, then every newly opened connection will start with inactive Cancel on Disconnect.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_edit_request_advanced as enum (
    'implv',
    'usd'
);

create type deribit.private_edit_request as (
    "order_id" text,
    "amount" double precision,
    "contracts" double precision,
    "price" double precision,
    "post_only" boolean,
    "reduce_only" boolean,
    "reject_post_only" boolean,
    "advanced" deribit.private_edit_request_advanced,
    "trigger_price" double precision,
    "trigger_offset" double precision,
    "mmp" boolean,
    "valid_until" bigint
);

comment on column deribit.private_edit_request."order_id" is '(Required) The order id';
comment on column deribit.private_edit_request."amount" is 'It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is the underlying base currency coin. For options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH. The amount is a mandatory parameter if contracts parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_edit_request."contracts" is 'It represents the requested order size in contract units and can be passed instead of amount. The contracts is a mandatory parameter if amount parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_edit_request."price" is 'The order price in base currency. When editing an option order with advanced=usd, the field price should be the option price value in USD. When editing an option order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_edit_request."post_only" is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just below or above the spread (accordingly to the original order type). Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_edit_request."reduce_only" is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_edit_request."reject_post_only" is 'If an order is considered post-only and this field is set to true then the order is put to the order book unmodified or the request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_edit_request."advanced" is 'Advanced option order type. If you have posted an advanced option order, it is necessary to re-supply this parameter when editing it (Only for options)';
comment on column deribit.private_edit_request."trigger_price" is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_edit_request."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered';
comment on column deribit.private_edit_request."mmp" is 'Order MMP flag, only for order_type ''limit''';
comment on column deribit.private_edit_request."valid_until" is 'Timestamp, when provided server will start processing request in Matching Engine only before given timestamp, in other cases timed_out error will be responded. Remember that the given timestamp should be consistent with the server''s time, use /public/time method to obtain current server time.';

create type deribit.private_edit_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_edit_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_edit_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_edit_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_edit_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_edit_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_edit_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_edit_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_edit_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_edit_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_edit_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_edit_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_edit_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_edit_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_edit_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_edit_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_edit_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_edit_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_edit_response_trade."matching_id" is 'Always null';
comment on column deribit.private_edit_response_trade."price" is 'Price in base currency';
comment on column deribit.private_edit_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_edit_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_edit_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_edit_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_edit_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_edit_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_edit_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_edit_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_edit_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_edit_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_edit_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_edit_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_edit_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_edit_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_edit_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_edit_response_order as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_edit_response_order."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_edit_response_order."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_edit_response_order."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_edit_response_order."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_edit_response_order."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_edit_response_order."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_edit_response_order."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_edit_response_order."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_edit_response_order."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_edit_response_order."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_edit_response_order."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_edit_response_order."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_edit_response_order."api" is 'true if created with API';
comment on column deribit.private_edit_response_order."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_edit_response_order."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_edit_response_order."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_edit_response_order."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_edit_response_order."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_edit_response_order."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_edit_response_order."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_edit_response_order."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_response_order."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_edit_response_order."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_edit_response_order."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_edit_response_order."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_edit_response_order."direction" is 'Direction: buy, or sell';
comment on column deribit.private_edit_response_order."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_edit_response_order."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_edit_response_order."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_edit_response_order."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_edit_response_order."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_edit_response_order."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_edit_response_order."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_response_order."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_edit_response_order."post_only" is 'true for post-only orders only';
comment on column deribit.private_edit_response_order."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_edit_response_order."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_edit_response_order."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_edit_response_order."order_id" is 'Unique order identifier';
comment on column deribit.private_edit_response_order."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_edit_response_order."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_edit_response_order."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_edit_response_order."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_edit_response_order."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_edit_response_order."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_edit_response_order."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_edit_response_order."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_edit_response_order."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_edit_response_order."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_edit_response_order."average_price" is 'Average fill price of the order';
comment on column deribit.private_edit_response_order."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_edit_response_result as (
    "order" deribit.private_edit_response_order,
    "trades" deribit.private_edit_response_trade[]
);

create type deribit.private_edit_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_edit_response_result
);

comment on column deribit.private_edit_response."id" is 'The id that was sent in the request';
comment on column deribit.private_edit_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_edit(
    "order_id" text,
    "amount" double precision default null,
    "contracts" double precision default null,
    "price" double precision default null,
    "post_only" boolean default null,
    "reduce_only" boolean default null,
    "reject_post_only" boolean default null,
    "advanced" deribit.private_edit_request_advanced default null,
    "trigger_price" double precision default null,
    "trigger_offset" double precision default null,
    "mmp" boolean default null,
    "valid_until" bigint default null
)
returns deribit.private_edit_response_result
language sql
as $$
    
    with request as (
        select row(
            "order_id",
            "amount",
            "contracts",
            "price",
            "post_only",
            "reduce_only",
            "reject_post_only",
            "advanced",
            "trigger_price",
            "trigger_offset",
            "mmp",
            "valid_until"
        )::deribit.private_edit_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/edit'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_edit_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_edit is 'Change price, amount and/or other properties of an order.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_edit_api_key_request as (
    "id" bigint,
    "max_scope" text,
    "name" text,
    "enabled" boolean,
    "enabled_features" text[],
    "ip_whitelist" text[]
);

comment on column deribit.private_edit_api_key_request."id" is '(Required) Id of key';
comment on column deribit.private_edit_api_key_request."max_scope" is '(Required) Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_edit_api_key_request."name" is 'Name of key (only letters, numbers and underscores allowed; maximum length - 16 characters)';
comment on column deribit.private_edit_api_key_request."enabled" is 'Enables/disables the API key. true to enable, false to disable';
comment on column deribit.private_edit_api_key_request."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_edit_api_key_request."ip_whitelist" is 'Whitelist provided IP address on a selected key';

create type deribit.private_edit_api_key_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_edit_api_key_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_edit_api_key_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_edit_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_edit_api_key_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_edit_api_key_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_edit_api_key_response_result."id" is 'key identifier';
comment on column deribit.private_edit_api_key_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_edit_api_key_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_edit_api_key_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_edit_api_key_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_edit_api_key_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_edit_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_edit_api_key_response_result
);

comment on column deribit.private_edit_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_edit_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_edit_api_key(
    "id" bigint,
    "max_scope" text,
    "name" text default null,
    "enabled" boolean default null,
    "enabled_features" text[] default null,
    "ip_whitelist" text[] default null
)
returns deribit.private_edit_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
            "id",
            "max_scope",
            "name",
            "enabled",
            "enabled_features",
            "ip_whitelist"
        )::deribit.private_edit_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/edit_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_edit_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_edit_api_key is 'Edits existing API key. At least one parameter is required. Important notes';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_edit_by_label_request_advanced as enum (
    'implv',
    'usd'
);

create type deribit.private_edit_by_label_request as (
    "label" text,
    "instrument_name" text,
    "amount" double precision,
    "contracts" double precision,
    "price" double precision,
    "post_only" boolean,
    "reduce_only" boolean,
    "reject_post_only" boolean,
    "advanced" deribit.private_edit_by_label_request_advanced,
    "trigger_price" double precision,
    "mmp" boolean,
    "valid_until" bigint
);

comment on column deribit.private_edit_by_label_request."label" is 'user defined label for the order (maximum 64 characters)';
comment on column deribit.private_edit_by_label_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_edit_by_label_request."amount" is 'It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is the underlying base currency coin. For options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH. The amount is a mandatory parameter if contracts parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_edit_by_label_request."contracts" is 'It represents the requested order size in contract units and can be passed instead of amount. The contracts is a mandatory parameter if amount parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_edit_by_label_request."price" is 'The order price in base currency. When editing an option order with advanced=usd, the field price should be the option price value in USD. When editing an option order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_edit_by_label_request."post_only" is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just below or above the spread (accordingly to the original order type). Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_edit_by_label_request."reduce_only" is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_edit_by_label_request."reject_post_only" is 'If an order is considered post-only and this field is set to true then the order is put to the order book unmodified or the request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_edit_by_label_request."advanced" is 'Advanced option order type. If you have posted an advanced option order, it is necessary to re-supply this parameter when editing it (Only for options)';
comment on column deribit.private_edit_by_label_request."trigger_price" is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_edit_by_label_request."mmp" is 'Order MMP flag, only for order_type ''limit''';
comment on column deribit.private_edit_by_label_request."valid_until" is 'Timestamp, when provided server will start processing request in Matching Engine only before given timestamp, in other cases timed_out error will be responded. Remember that the given timestamp should be consistent with the server''s time, use /public/time method to obtain current server time.';

create type deribit.private_edit_by_label_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_edit_by_label_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_edit_by_label_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_edit_by_label_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_edit_by_label_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_edit_by_label_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_edit_by_label_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_edit_by_label_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_edit_by_label_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_edit_by_label_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_edit_by_label_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_edit_by_label_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_edit_by_label_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_edit_by_label_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_edit_by_label_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_edit_by_label_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_edit_by_label_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_edit_by_label_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_edit_by_label_response_trade."matching_id" is 'Always null';
comment on column deribit.private_edit_by_label_response_trade."price" is 'Price in base currency';
comment on column deribit.private_edit_by_label_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_edit_by_label_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_by_label_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_edit_by_label_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_edit_by_label_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_edit_by_label_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_edit_by_label_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_edit_by_label_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_edit_by_label_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_edit_by_label_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_edit_by_label_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_edit_by_label_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_edit_by_label_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_edit_by_label_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_edit_by_label_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_edit_by_label_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_edit_by_label_response_order as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_edit_by_label_response_order."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_edit_by_label_response_order."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_edit_by_label_response_order."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_edit_by_label_response_order."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_edit_by_label_response_order."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_edit_by_label_response_order."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_edit_by_label_response_order."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_edit_by_label_response_order."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_edit_by_label_response_order."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_edit_by_label_response_order."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_edit_by_label_response_order."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_edit_by_label_response_order."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_edit_by_label_response_order."api" is 'true if created with API';
comment on column deribit.private_edit_by_label_response_order."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_edit_by_label_response_order."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_edit_by_label_response_order."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_edit_by_label_response_order."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_edit_by_label_response_order."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_edit_by_label_response_order."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_edit_by_label_response_order."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_edit_by_label_response_order."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_by_label_response_order."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_edit_by_label_response_order."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_edit_by_label_response_order."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_edit_by_label_response_order."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_edit_by_label_response_order."direction" is 'Direction: buy, or sell';
comment on column deribit.private_edit_by_label_response_order."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_edit_by_label_response_order."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_edit_by_label_response_order."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_edit_by_label_response_order."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_edit_by_label_response_order."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_edit_by_label_response_order."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_edit_by_label_response_order."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_edit_by_label_response_order."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_edit_by_label_response_order."post_only" is 'true for post-only orders only';
comment on column deribit.private_edit_by_label_response_order."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_edit_by_label_response_order."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_edit_by_label_response_order."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_edit_by_label_response_order."order_id" is 'Unique order identifier';
comment on column deribit.private_edit_by_label_response_order."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_edit_by_label_response_order."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_edit_by_label_response_order."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_edit_by_label_response_order."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_edit_by_label_response_order."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_edit_by_label_response_order."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_edit_by_label_response_order."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_edit_by_label_response_order."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_edit_by_label_response_order."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_edit_by_label_response_order."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_edit_by_label_response_order."average_price" is 'Average fill price of the order';
comment on column deribit.private_edit_by_label_response_order."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_edit_by_label_response_result as (
    "order" deribit.private_edit_by_label_response_order,
    "trades" deribit.private_edit_by_label_response_trade[]
);

create type deribit.private_edit_by_label_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_edit_by_label_response_result
);

comment on column deribit.private_edit_by_label_response."id" is 'The id that was sent in the request';
comment on column deribit.private_edit_by_label_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_edit_by_label(
    "instrument_name" text,
    "label" text default null,
    "amount" double precision default null,
    "contracts" double precision default null,
    "price" double precision default null,
    "post_only" boolean default null,
    "reduce_only" boolean default null,
    "reject_post_only" boolean default null,
    "advanced" deribit.private_edit_by_label_request_advanced default null,
    "trigger_price" double precision default null,
    "mmp" boolean default null,
    "valid_until" bigint default null
)
returns deribit.private_edit_by_label_response_result
language sql
as $$
    
    with request as (
        select row(
            "label",
            "instrument_name",
            "amount",
            "contracts",
            "price",
            "post_only",
            "reduce_only",
            "reject_post_only",
            "advanced",
            "trigger_price",
            "mmp",
            "valid_until"
        )::deribit.private_edit_by_label_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/edit_by_label'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_edit_by_label_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_edit_by_label is 'Change price, amount and/or other properties of an order with a given label. It works only when there is one open order with this label';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_enable_affiliate_program_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_enable_affiliate_program_response."id" is 'The id that was sent in the request';
comment on column deribit.private_enable_affiliate_program_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_enable_affiliate_program_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_enable_affiliate_program()
returns text
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/enable_affiliate_program'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.private_enable_affiliate_program_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_enable_affiliate_program is 'Enables affiliate program for user';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_enable_api_key_request as (
    "id" bigint
);

comment on column deribit.private_enable_api_key_request."id" is '(Required) Id of key';

create type deribit.private_enable_api_key_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_enable_api_key_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_enable_api_key_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_enable_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_enable_api_key_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_enable_api_key_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_enable_api_key_response_result."id" is 'key identifier';
comment on column deribit.private_enable_api_key_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_enable_api_key_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_enable_api_key_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_enable_api_key_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_enable_api_key_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_enable_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_enable_api_key_response_result
);

comment on column deribit.private_enable_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_enable_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_enable_api_key(
    "id" bigint
)
returns deribit.private_enable_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
            "id"
        )::deribit.private_enable_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/enable_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_enable_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_enable_api_key is 'Enables api key with given id. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_enable_cancel_on_disconnect_request_scope as enum (
    'account',
    'connection'
);

create type deribit.private_enable_cancel_on_disconnect_request as (
    "scope" deribit.private_enable_cancel_on_disconnect_request_scope
);

comment on column deribit.private_enable_cancel_on_disconnect_request."scope" is 'Specifies if Cancel On Disconnect change should be applied/checked for the current connection or the account (default - connection)  NOTICE: Scope connection can be used only when working via Websocket.';

create type deribit.private_enable_cancel_on_disconnect_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_enable_cancel_on_disconnect_response."id" is 'The id that was sent in the request';
comment on column deribit.private_enable_cancel_on_disconnect_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_enable_cancel_on_disconnect_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_enable_cancel_on_disconnect(
    "scope" deribit.private_enable_cancel_on_disconnect_request_scope default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "scope"
        )::deribit.private_enable_cancel_on_disconnect_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/enable_cancel_on_disconnect'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_enable_cancel_on_disconnect_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_enable_cancel_on_disconnect is 'Enable Cancel On Disconnect for the connection. After enabling Cancel On Disconnect all orders created by the connection will be removed when the connection is closed.  NOTICE It does not affect orders created by other connections - they will remain active ! When change is applied for the account, then every newly opened connection will start with active Cancel on Disconnect.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_execute_block_trade_request_trade_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_execute_block_trade_request_role as enum (
    'maker',
    'taker'
);

create type deribit.private_execute_block_trade_request_trade as (
    "instrument_name" text,
    "price" double precision,
    "amount" double precision,
    "direction" deribit.private_execute_block_trade_request_trade_direction
);

comment on column deribit.private_execute_block_trade_request_trade."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_execute_block_trade_request_trade."price" is '(Required) Price for trade';
comment on column deribit.private_execute_block_trade_request_trade."amount" is 'It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_execute_block_trade_request_trade."direction" is '(Required) Direction of trade from the maker perspective';

create type deribit.private_execute_block_trade_request as (
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_execute_block_trade_request_role,
    "trades" deribit.private_execute_block_trade_request_trade[],
    "counterparty_signature" text
);

comment on column deribit.private_execute_block_trade_request."timestamp" is '(Required) Timestamp, shared with other party (milliseconds since the UNIX epoch)';
comment on column deribit.private_execute_block_trade_request."nonce" is '(Required) Nonce, shared with other party';
comment on column deribit.private_execute_block_trade_request."role" is '(Required) Describes if user wants to be maker or taker of trades';
comment on column deribit.private_execute_block_trade_request."trades" is '(Required) List of trades for block trade';
comment on column deribit.private_execute_block_trade_request."counterparty_signature" is '(Required) Signature of block trade generated by private/verify_block_trade_method';

create type deribit.private_execute_block_trade_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_execute_block_trade_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_execute_block_trade_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_execute_block_trade_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_execute_block_trade_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_execute_block_trade_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_execute_block_trade_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_execute_block_trade_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_execute_block_trade_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_execute_block_trade_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_execute_block_trade_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_execute_block_trade_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_execute_block_trade_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_execute_block_trade_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_execute_block_trade_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_execute_block_trade_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_execute_block_trade_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_execute_block_trade_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_execute_block_trade_response_trade."matching_id" is 'Always null';
comment on column deribit.private_execute_block_trade_response_trade."price" is 'Price in base currency';
comment on column deribit.private_execute_block_trade_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_execute_block_trade_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_execute_block_trade_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_execute_block_trade_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_execute_block_trade_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_execute_block_trade_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_execute_block_trade_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_execute_block_trade_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_execute_block_trade_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_execute_block_trade_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_execute_block_trade_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_execute_block_trade_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_execute_block_trade_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_execute_block_trade_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_execute_block_trade_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_execute_block_trade_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_execute_block_trade_response_result as (
    "app_name" text,
    "id" text,
    "timestamp" bigint,
    "trades" deribit.private_execute_block_trade_response_trade[]
);

comment on column deribit.private_execute_block_trade_response_result."app_name" is 'The name of the application that executed the block trade on behalf of the user (optional).';
comment on column deribit.private_execute_block_trade_response_result."id" is 'Block trade id';
comment on column deribit.private_execute_block_trade_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_execute_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_execute_block_trade_response_result
);

comment on column deribit.private_execute_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_execute_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_execute_block_trade(
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_execute_block_trade_request_role,
    "trades" deribit.private_execute_block_trade_request_trade[],
    "counterparty_signature" text
)
returns deribit.private_execute_block_trade_response_result
language sql
as $$
    
    with request as (
        select row(
            "timestamp",
            "nonce",
            "role",
            "trades",
            "counterparty_signature"
        )::deribit.private_execute_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/execute_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_execute_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_execute_block_trade is 'Creates block tradeThe whole request have to be exact the same as in private/verify_block_trade, only role field should be set appropriately - it basically means that both sides have to agree on the same timestamp, nonce, trades fields and server will assure that role field is different between sides (each party accepted own role). Using the same timestamp and nonce by both sides in private/verify_block_trade assures that even if unintentionally both sides execute given block trade with valid counterparty_signature, the given block trade will be executed only once.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_access_log_request as (
    "offset" bigint,
    "count" bigint
);

comment on column deribit.private_get_access_log_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.private_get_access_log_request."count" is 'Number of requested items, default - 10';

create type deribit.private_get_access_log_response_result as (
    "city" text,
    "country" text,
    "data" text,
    "id" bigint,
    "ip" text,
    "log" text,
    "timestamp" bigint
);

comment on column deribit.private_get_access_log_response_result."city" is 'City where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result."country" is 'Country where the IP address is registered (estimated)';
comment on column deribit.private_get_access_log_response_result."data" is 'Optional, additional information about action, type depends on log value';
comment on column deribit.private_get_access_log_response_result."id" is 'Unique identifier';
comment on column deribit.private_get_access_log_response_result."ip" is 'IP address of source that generated action';
comment on column deribit.private_get_access_log_response_result."log" is 'Action description, values: changed_email - email was changed; changed_password - password was changed; disabled_tfa - TFA was disabled; enabled_tfa - TFA was enabled, success - successful login; failure - login failure; enabled_subaccount_login - login was enabled for subaccount (in data - subaccount uid); disabled_subaccount_login - login was disabled for subbaccount (in data - subbacount uid);new_api_key - API key was created (in data key client id); removed_api_key - API key was removed (in data key client id); changed_scope - scope of API key was changed (in data key client id); changed_whitelist - whitelist of API key was edited (in data key client id); disabled_api_key - API key was disabled (in data key client id); enabled_api_key - API key was enabled (in data key client id); reset_api_key - API key was reset (in data key client id)';
comment on column deribit.private_get_access_log_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_access_log_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_access_log_response_result[]
);

comment on column deribit.private_get_access_log_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_access_log_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_access_log(
    "offset" bigint default null,
    "count" bigint default null
)
returns setof deribit.private_get_access_log_response_result
language sql
as $$
    
    with request as (
        select row(
            "offset",
            "count"
        )::deribit.private_get_access_log_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_access_log'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_access_log_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."city"::text,
        (b)."country"::text,
        (b)."data"::text,
        (b)."id"::bigint,
        (b)."ip"::text,
        (b)."log"::text,
        (b)."timestamp"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_access_log is 'Lists access logs for the user';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_account_summaries_request as (
    "subaccount_id" bigint,
    "extended" boolean
);

comment on column deribit.private_get_account_summaries_request."subaccount_id" is 'The user id for the subaccount';
comment on column deribit.private_get_account_summaries_request."extended" is 'Include additional fields';

create type deribit.private_get_account_summaries_response_fee as (
    "currency" text,
    "fee_type" text,
    "instrument_type" text,
    "maker_fee" double precision,
    "taker_fee" double precision
);

comment on column deribit.private_get_account_summaries_response_fee."currency" is 'The currency the fee applies to';
comment on column deribit.private_get_account_summaries_response_fee."fee_type" is 'Fee type - relative if fee is calculated as a fraction of base instrument fee, fixed if fee is calculated solely using user fee';
comment on column deribit.private_get_account_summaries_response_fee."instrument_type" is 'Type of the instruments the fee applies to - future for future instruments (excluding perpetual), perpetual for future perpetual instruments, option for options';
comment on column deribit.private_get_account_summaries_response_fee."maker_fee" is 'User fee as a maker';
comment on column deribit.private_get_account_summaries_response_fee."taker_fee" is 'User fee as a taker';

create type deribit.private_get_account_summaries_response_summary as (
    "maintenance_margin" double precision,
    "delta_total" double precision,
    "options_session_rpl" double precision,
    "futures_session_rpl" double precision,
    "session_upl" double precision,
    "fee_balance" double precision,
    "fees" deribit.private_get_account_summaries_response_fee[],
    "limits" jsonb,
    "initial_margin" double precision,
    "options_gamma_map" jsonb,
    "futures_pl" double precision,
    "currency" text,
    "options_value" double precision,
    "projected_maintenance_margin" double precision,
    "options_vega" double precision,
    "session_rpl" double precision,
    "has_non_block_chain_equity" boolean,
    "deposit_address" text,
    "total_initial_margin_usd" double precision,
    "futures_session_upl" double precision,
    "options_session_upl" double precision,
    "cross_collateral_enabled" boolean,
    "options_theta" double precision,
    "margin_model" text,
    "options_delta" double precision,
    "options_pl" double precision,
    "options_vega_map" jsonb,
    "balance" double precision,
    "total_equity_usd" double precision,
    "additional_reserve" double precision,
    "projected_initial_margin" double precision,
    "available_funds" double precision,
    "spot_reserve" double precision,
    "projected_delta_total" double precision,
    "portfolio_margining_enabled" boolean,
    "total_maintenance_margin_usd" double precision,
    "total_margin_balance_usd" double precision,
    "total_pl" double precision,
    "margin_balance" double precision,
    "options_theta_map" jsonb,
    "total_delta_total_usd" double precision,
    "available_withdrawal_funds" double precision,
    "equity" double precision,
    "options_gamma" double precision,
    "delta_total_map" jsonb,
    "estimated_liquidation_ratio_map" jsonb,
    "estimated_liquidation_ratio" double precision
);

comment on column deribit.private_get_account_summaries_response_summary."maintenance_margin" is 'The maintenance margin.';
comment on column deribit.private_get_account_summaries_response_summary."delta_total" is 'The sum of position deltas';
comment on column deribit.private_get_account_summaries_response_summary."options_session_rpl" is 'Options session realized profit and Loss';
comment on column deribit.private_get_account_summaries_response_summary."futures_session_rpl" is 'Futures session realized profit and Loss';
comment on column deribit.private_get_account_summaries_response_summary."session_upl" is 'Session unrealized profit and loss';
comment on column deribit.private_get_account_summaries_response_summary."fee_balance" is 'The account''s fee balance (it can be used to pay for fees)';
comment on column deribit.private_get_account_summaries_response_summary."fees" is 'User fees in case of any discounts (available when parameter extended = true and user has any discounts)';
comment on column deribit.private_get_account_summaries_response_summary."limits" is 'Returned object is described in separate document.';
comment on column deribit.private_get_account_summaries_response_summary."initial_margin" is 'The account''s initial margin';
comment on column deribit.private_get_account_summaries_response_summary."options_gamma_map" is 'Map of options'' gammas per index';
comment on column deribit.private_get_account_summaries_response_summary."futures_pl" is 'Futures profit and Loss';
comment on column deribit.private_get_account_summaries_response_summary."currency" is 'Currency of the summary';
comment on column deribit.private_get_account_summaries_response_summary."options_value" is 'Options value';
comment on column deribit.private_get_account_summaries_response_summary."projected_maintenance_margin" is 'Projected maintenance margin';
comment on column deribit.private_get_account_summaries_response_summary."options_vega" is 'Options summary vega';
comment on column deribit.private_get_account_summaries_response_summary."session_rpl" is 'Session realized profit and loss';
comment on column deribit.private_get_account_summaries_response_summary."has_non_block_chain_equity" is 'Optional field returned with value true when user has non block chain equity that is excluded from proof of reserve calculations';
comment on column deribit.private_get_account_summaries_response_summary."deposit_address" is 'The deposit address for the account (if available)';
comment on column deribit.private_get_account_summaries_response_summary."total_initial_margin_usd" is 'Optional (only for users using cross margin). The account''s total initial margin in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summaries_response_summary."futures_session_upl" is 'Futures session unrealized profit and Loss';
comment on column deribit.private_get_account_summaries_response_summary."options_session_upl" is 'Options session unrealized profit and Loss';
comment on column deribit.private_get_account_summaries_response_summary."cross_collateral_enabled" is 'When true cross collateral is enabled for user';
comment on column deribit.private_get_account_summaries_response_summary."options_theta" is 'Options summary theta';
comment on column deribit.private_get_account_summaries_response_summary."margin_model" is 'Name of user''s currently enabled margin model';
comment on column deribit.private_get_account_summaries_response_summary."options_delta" is 'Options summary delta';
comment on column deribit.private_get_account_summaries_response_summary."options_pl" is 'Options profit and Loss';
comment on column deribit.private_get_account_summaries_response_summary."options_vega_map" is 'Map of options'' vegas per index';
comment on column deribit.private_get_account_summaries_response_summary."balance" is 'The account''s balance';
comment on column deribit.private_get_account_summaries_response_summary."total_equity_usd" is 'Optional (only for users using cross margin). The account''s total equity in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summaries_response_summary."additional_reserve" is 'The account''s balance reserved in other orders';
comment on column deribit.private_get_account_summaries_response_summary."projected_initial_margin" is 'Projected initial margin';
comment on column deribit.private_get_account_summaries_response_summary."available_funds" is 'The account''s available funds';
comment on column deribit.private_get_account_summaries_response_summary."spot_reserve" is 'The account''s balance reserved in active spot orders';
comment on column deribit.private_get_account_summaries_response_summary."projected_delta_total" is 'The sum of position deltas without positions that will expire during closest expiration';
comment on column deribit.private_get_account_summaries_response_summary."portfolio_margining_enabled" is 'true when portfolio margining is enabled for user';
comment on column deribit.private_get_account_summaries_response_summary."total_maintenance_margin_usd" is 'Optional (only for users using cross margin). The account''s total maintenance margin in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summaries_response_summary."total_margin_balance_usd" is 'Optional (only for users using cross margin). The account''s total margin balance in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summaries_response_summary."total_pl" is 'Profit and loss';
comment on column deribit.private_get_account_summaries_response_summary."margin_balance" is 'The account''s margin balance';
comment on column deribit.private_get_account_summaries_response_summary."options_theta_map" is 'Map of options'' thetas per index';
comment on column deribit.private_get_account_summaries_response_summary."total_delta_total_usd" is 'Optional (only for users using cross margin). The account''s total delta total in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summaries_response_summary."available_withdrawal_funds" is 'The account''s available to withdrawal funds';
comment on column deribit.private_get_account_summaries_response_summary."equity" is 'The account''s current equity';
comment on column deribit.private_get_account_summaries_response_summary."options_gamma" is 'Options summary gamma';

create type deribit.private_get_account_summaries_response_result as (
    "creation_timestamp" bigint,
    "email" text,
    "id" bigint,
    "interuser_transfers_enabled" boolean,
    "login_enabled" boolean,
    "mmp_enabled" boolean,
    "referrer_id" text,
    "security_keys_enabled" boolean,
    "self_trading_extended_to_subaccounts" text,
    "self_trading_reject_mode" text,
    "summaries" deribit.private_get_account_summaries_response_summary[],
    "system_name" text,
    "type" text,
    "username" text
);

comment on column deribit.private_get_account_summaries_response_result."creation_timestamp" is 'Time at which the account was created (milliseconds since the Unix epoch; available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."email" is 'User email (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."id" is 'Account id (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."interuser_transfers_enabled" is 'true when the inter-user transfers are enabled for user (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."login_enabled" is 'Whether account is loginable using email and password (available when parameter extended = true and account is a subaccount)';
comment on column deribit.private_get_account_summaries_response_result."mmp_enabled" is 'Whether MMP is enabled (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."referrer_id" is 'Optional identifier of the referrer (of the affiliation program, and available when parameter extended = true), which link was used by this account at registration. It coincides with suffix of the affiliation link path after /reg-';
comment on column deribit.private_get_account_summaries_response_result."security_keys_enabled" is 'Whether Security Key authentication is enabled (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."self_trading_extended_to_subaccounts" is 'true if self trading rejection behavior is applied to trades between subaccounts (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."self_trading_reject_mode" is 'Self trading rejection behavior - reject_taker or cancel_maker (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."summaries" is 'Aggregated list of per-currency account summaries';
comment on column deribit.private_get_account_summaries_response_result."system_name" is 'System generated user nickname (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."type" is 'Account type (available when parameter extended = true)';
comment on column deribit.private_get_account_summaries_response_result."username" is 'Account name (given by user) (available when parameter extended = true)';

create type deribit.private_get_account_summaries_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_account_summaries_response_result
);

comment on column deribit.private_get_account_summaries_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_account_summaries_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_account_summaries(
    "subaccount_id" bigint default null,
    "extended" boolean default null
)
returns deribit.private_get_account_summaries_response_result
language sql
as $$
    
    with request as (
        select row(
            "subaccount_id",
            "extended"
        )::deribit.private_get_account_summaries_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_account_summaries'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_account_summaries_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_account_summaries is 'Retrieves a per-currency list of user account summaries. To read subaccount summary use subaccount_id parameter.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_account_summary_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_account_summary_request as (
    "currency" deribit.private_get_account_summary_request_currency,
    "subaccount_id" bigint,
    "extended" boolean
);

comment on column deribit.private_get_account_summary_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_account_summary_request."subaccount_id" is 'The user id for the subaccount';
comment on column deribit.private_get_account_summary_request."extended" is 'Include additional fields';

create type deribit.private_get_account_summary_response_fee as (
    "currency" text,
    "fee_type" text,
    "instrument_type" text,
    "maker_fee" double precision,
    "taker_fee" double precision
);

comment on column deribit.private_get_account_summary_response_fee."currency" is 'The currency the fee applies to';
comment on column deribit.private_get_account_summary_response_fee."fee_type" is 'Fee type - relative if fee is calculated as a fraction of base instrument fee, fixed if fee is calculated solely using user fee';
comment on column deribit.private_get_account_summary_response_fee."instrument_type" is 'Type of the instruments the fee applies to - future for future instruments (excluding perpetual), perpetual for future perpetual instruments, option for options';
comment on column deribit.private_get_account_summary_response_fee."maker_fee" is 'User fee as a maker';
comment on column deribit.private_get_account_summary_response_fee."taker_fee" is 'User fee as a taker';

create type deribit.private_get_account_summary_response_result as (
    "maintenance_margin" double precision,
    "delta_total" double precision,
    "id" bigint,
    "options_session_rpl" double precision,
    "self_trading_reject_mode" text,
    "futures_session_rpl" double precision,
    "session_upl" double precision,
    "fee_balance" double precision,
    "fees" deribit.private_get_account_summary_response_fee[],
    "limits" jsonb,
    "type" text,
    "initial_margin" double precision,
    "options_gamma_map" jsonb,
    "futures_pl" double precision,
    "currency" text,
    "options_value" double precision,
    "security_keys_enabled" boolean,
    "self_trading_extended_to_subaccounts" text,
    "projected_maintenance_margin" double precision,
    "options_vega" double precision,
    "session_rpl" double precision,
    "has_non_block_chain_equity" boolean,
    "system_name" text,
    "deposit_address" text,
    "total_initial_margin_usd" double precision,
    "futures_session_upl" double precision,
    "options_session_upl" double precision,
    "referrer_id" text,
    "cross_collateral_enabled" boolean,
    "options_theta" double precision,
    "login_enabled" boolean,
    "margin_model" text,
    "username" text,
    "interuser_transfers_enabled" boolean,
    "options_delta" double precision,
    "options_pl" double precision,
    "options_vega_map" jsonb,
    "balance" double precision,
    "total_equity_usd" double precision,
    "additional_reserve" double precision,
    "mmp_enabled" boolean,
    "projected_initial_margin" double precision,
    "email" text,
    "available_funds" double precision,
    "spot_reserve" double precision,
    "projected_delta_total" double precision,
    "portfolio_margining_enabled" boolean,
    "total_maintenance_margin_usd" double precision,
    "total_margin_balance_usd" double precision,
    "total_pl" double precision,
    "margin_balance" double precision,
    "options_theta_map" jsonb,
    "total_delta_total_usd" double precision,
    "creation_timestamp" bigint,
    "available_withdrawal_funds" double precision,
    "equity" double precision,
    "options_gamma" double precision,
    "delta_total_map" jsonb,
    "estimated_liquidation_ratio_map" jsonb,
    "estimated_liquidation_ratio" double precision
);

comment on column deribit.private_get_account_summary_response_result."maintenance_margin" is 'The maintenance margin.';
comment on column deribit.private_get_account_summary_response_result."delta_total" is 'The sum of position deltas';
comment on column deribit.private_get_account_summary_response_result."id" is 'Account id (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."options_session_rpl" is 'Options session realized profit and Loss';
comment on column deribit.private_get_account_summary_response_result."self_trading_reject_mode" is 'Self trading rejection behavior - reject_taker or cancel_maker (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."futures_session_rpl" is 'Futures session realized profit and Loss';
comment on column deribit.private_get_account_summary_response_result."session_upl" is 'Session unrealized profit and loss';
comment on column deribit.private_get_account_summary_response_result."fee_balance" is 'The account''s fee balance (it can be used to pay for fees)';
comment on column deribit.private_get_account_summary_response_result."fees" is 'User fees in case of any discounts (available when parameter extended = true and user has any discounts)';
comment on column deribit.private_get_account_summary_response_result."limits" is 'Returned object is described in separate document.';
comment on column deribit.private_get_account_summary_response_result."type" is 'Account type (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."initial_margin" is 'The account''s initial margin';
comment on column deribit.private_get_account_summary_response_result."options_gamma_map" is 'Map of options'' gammas per index';
comment on column deribit.private_get_account_summary_response_result."futures_pl" is 'Futures profit and Loss';
comment on column deribit.private_get_account_summary_response_result."currency" is 'The selected currency';
comment on column deribit.private_get_account_summary_response_result."options_value" is 'Options value';
comment on column deribit.private_get_account_summary_response_result."security_keys_enabled" is 'Whether Security Key authentication is enabled (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."self_trading_extended_to_subaccounts" is 'true if self trading rejection behavior is applied to trades between subaccounts (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."projected_maintenance_margin" is 'Projected maintenance margin';
comment on column deribit.private_get_account_summary_response_result."options_vega" is 'Options summary vega';
comment on column deribit.private_get_account_summary_response_result."session_rpl" is 'Session realized profit and loss';
comment on column deribit.private_get_account_summary_response_result."has_non_block_chain_equity" is 'Optional field returned with value true when user has non block chain equity that is excluded from proof of reserve calculations';
comment on column deribit.private_get_account_summary_response_result."system_name" is 'System generated user nickname (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."deposit_address" is 'The deposit address for the account (if available)';
comment on column deribit.private_get_account_summary_response_result."total_initial_margin_usd" is 'Optional (only for users using cross margin). The account''s total initial margin in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summary_response_result."futures_session_upl" is 'Futures session unrealized profit and Loss';
comment on column deribit.private_get_account_summary_response_result."options_session_upl" is 'Options session unrealized profit and Loss';
comment on column deribit.private_get_account_summary_response_result."referrer_id" is 'Optional identifier of the referrer (of the affiliation program, and available when parameter extended = true), which link was used by this account at registration. It coincides with suffix of the affiliation link path after /reg-';
comment on column deribit.private_get_account_summary_response_result."cross_collateral_enabled" is 'When true cross collateral is enabled for user';
comment on column deribit.private_get_account_summary_response_result."options_theta" is 'Options summary theta';
comment on column deribit.private_get_account_summary_response_result."login_enabled" is 'Whether account is loginable using email and password (available when parameter extended = true and account is a subaccount)';
comment on column deribit.private_get_account_summary_response_result."margin_model" is 'Name of user''s currently enabled margin model';
comment on column deribit.private_get_account_summary_response_result."username" is 'Account name (given by user) (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."interuser_transfers_enabled" is 'true when the inter-user transfers are enabled for user (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."options_delta" is 'Options summary delta';
comment on column deribit.private_get_account_summary_response_result."options_pl" is 'Options profit and Loss';
comment on column deribit.private_get_account_summary_response_result."options_vega_map" is 'Map of options'' vegas per index';
comment on column deribit.private_get_account_summary_response_result."balance" is 'The account''s balance';
comment on column deribit.private_get_account_summary_response_result."total_equity_usd" is 'Optional (only for users using cross margin). The account''s total equity in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summary_response_result."additional_reserve" is 'The account''s balance reserved in other orders';
comment on column deribit.private_get_account_summary_response_result."mmp_enabled" is 'Whether MMP is enabled (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."projected_initial_margin" is 'Projected initial margin';
comment on column deribit.private_get_account_summary_response_result."email" is 'User email (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."available_funds" is 'The account''s available funds';
comment on column deribit.private_get_account_summary_response_result."spot_reserve" is 'The account''s balance reserved in active spot orders';
comment on column deribit.private_get_account_summary_response_result."projected_delta_total" is 'The sum of position deltas without positions that will expire during closest expiration';
comment on column deribit.private_get_account_summary_response_result."portfolio_margining_enabled" is 'true when portfolio margining is enabled for user';
comment on column deribit.private_get_account_summary_response_result."total_maintenance_margin_usd" is 'Optional (only for users using cross margin). The account''s total maintenance margin in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summary_response_result."total_margin_balance_usd" is 'Optional (only for users using cross margin). The account''s total margin balance in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summary_response_result."total_pl" is 'Profit and loss';
comment on column deribit.private_get_account_summary_response_result."margin_balance" is 'The account''s margin balance';
comment on column deribit.private_get_account_summary_response_result."options_theta_map" is 'Map of options'' thetas per index';
comment on column deribit.private_get_account_summary_response_result."total_delta_total_usd" is 'Optional (only for users using cross margin). The account''s total delta total in all cross collateral currencies, expressed in USD';
comment on column deribit.private_get_account_summary_response_result."creation_timestamp" is 'Time at which the account was created (milliseconds since the Unix epoch; available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result."available_withdrawal_funds" is 'The account''s available to withdrawal funds';
comment on column deribit.private_get_account_summary_response_result."equity" is 'The account''s current equity';
comment on column deribit.private_get_account_summary_response_result."options_gamma" is 'Options summary gamma';

create type deribit.private_get_account_summary_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_account_summary_response_result
);

comment on column deribit.private_get_account_summary_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_account_summary_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_account_summary(
    "currency" deribit.private_get_account_summary_request_currency,
    "subaccount_id" bigint default null,
    "extended" boolean default null
)
returns deribit.private_get_account_summary_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "subaccount_id",
            "extended"
        )::deribit.private_get_account_summary_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_account_summary'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_account_summary_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_account_summary is 'Retrieves user account summary. To read subaccount summary use subaccount_id parameter.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_affiliate_program_info_response_received as (
    "btc" double precision,
    "eth" double precision
);

comment on column deribit.private_get_affiliate_program_info_response_received."btc" is 'Total payout received in BTC';
comment on column deribit.private_get_affiliate_program_info_response_received."eth" is 'Total payout received in ETH';

create type deribit.private_get_affiliate_program_info_response_result as (
    "is_enabled" boolean,
    "link" text,
    "number_of_affiliates" double precision,
    "received" deribit.private_get_affiliate_program_info_response_received
);

comment on column deribit.private_get_affiliate_program_info_response_result."is_enabled" is 'Status of affiliate program';
comment on column deribit.private_get_affiliate_program_info_response_result."link" is 'Affiliate link';
comment on column deribit.private_get_affiliate_program_info_response_result."number_of_affiliates" is 'Number of affiliates';

create type deribit.private_get_affiliate_program_info_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_affiliate_program_info_response_result
);

comment on column deribit.private_get_affiliate_program_info_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_affiliate_program_info_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_affiliate_program_info()
returns deribit.private_get_affiliate_program_info_response_result
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_affiliate_program_info'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_affiliate_program_info_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_affiliate_program_info is 'Retrieves user`s affiliates count, payouts and link.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_block_trade_request as (
    "id" text
);

comment on column deribit.private_get_block_trade_request."id" is '(Required) Block trade id';

create type deribit.private_get_block_trade_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_block_trade_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_block_trade_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_block_trade_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_block_trade_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_block_trade_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_block_trade_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_block_trade_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_get_block_trade_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_block_trade_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_block_trade_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_block_trade_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_block_trade_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_block_trade_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_block_trade_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_block_trade_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_block_trade_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_block_trade_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_block_trade_response_trade."matching_id" is 'Always null';
comment on column deribit.private_get_block_trade_response_trade."price" is 'Price in base currency';
comment on column deribit.private_get_block_trade_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_block_trade_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_block_trade_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_block_trade_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_block_trade_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_block_trade_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_block_trade_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_block_trade_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_block_trade_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_block_trade_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_block_trade_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_block_trade_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_block_trade_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_block_trade_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_block_trade_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_block_trade_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_block_trade_response_result as (
    "app_name" text,
    "id" text,
    "timestamp" bigint,
    "trades" deribit.private_get_block_trade_response_trade[]
);

comment on column deribit.private_get_block_trade_response_result."app_name" is 'The name of the application that executed the block trade on behalf of the user (optional).';
comment on column deribit.private_get_block_trade_response_result."id" is 'Block trade id';
comment on column deribit.private_get_block_trade_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_block_trade_response_result
);

comment on column deribit.private_get_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_block_trade(
    "id" text
)
returns deribit.private_get_block_trade_response_result
language sql
as $$
    
    with request as (
        select row(
            "id"
        )::deribit.private_get_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_block_trade is 'Returns information about the users block trade';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_cancel_on_disconnect_request_scope as enum (
    'account',
    'connection'
);

create type deribit.private_get_cancel_on_disconnect_request as (
    "scope" deribit.private_get_cancel_on_disconnect_request_scope
);

comment on column deribit.private_get_cancel_on_disconnect_request."scope" is 'Specifies if Cancel On Disconnect change should be applied/checked for the current connection or the account (default - connection)  NOTICE: Scope connection can be used only when working via Websocket.';

create type deribit.private_get_cancel_on_disconnect_response_result as (
    "enabled" boolean,
    "scope" text
);

comment on column deribit.private_get_cancel_on_disconnect_response_result."enabled" is 'Current configuration status';
comment on column deribit.private_get_cancel_on_disconnect_response_result."scope" is 'Informs if Cancel on Disconnect was checked for the current connection or the account';

create type deribit.private_get_cancel_on_disconnect_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_cancel_on_disconnect_response_result
);

comment on column deribit.private_get_cancel_on_disconnect_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_cancel_on_disconnect_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_cancel_on_disconnect(
    "scope" deribit.private_get_cancel_on_disconnect_request_scope default null
)
returns deribit.private_get_cancel_on_disconnect_response_result
language sql
as $$
    
    with request as (
        select row(
            "scope"
        )::deribit.private_get_cancel_on_disconnect_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_cancel_on_disconnect'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_cancel_on_disconnect_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_cancel_on_disconnect is 'Read current Cancel On Disconnect configuration for the account.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_current_deposit_address_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_current_deposit_address_request as (
    "currency" deribit.private_get_current_deposit_address_request_currency
);

comment on column deribit.private_get_current_deposit_address_request."currency" is '(Required) The currency symbol';

create type deribit.private_get_current_deposit_address_response_result as (
    "address" text,
    "creation_timestamp" bigint,
    "currency" text,
    "type" text
);

comment on column deribit.private_get_current_deposit_address_response_result."address" is 'Address in proper format for currency';
comment on column deribit.private_get_current_deposit_address_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_current_deposit_address_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_current_deposit_address_response_result."type" is 'Address type/purpose, allowed values : deposit, withdrawal, transfer';

create type deribit.private_get_current_deposit_address_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_current_deposit_address_response_result
);

comment on column deribit.private_get_current_deposit_address_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_current_deposit_address_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_current_deposit_address_response."result" is 'Object if address is created, null otherwise';

create function deribit.private_get_current_deposit_address(
    "currency" deribit.private_get_current_deposit_address_request_currency
)
returns deribit.private_get_current_deposit_address_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.private_get_current_deposit_address_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_current_deposit_address'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_current_deposit_address_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_current_deposit_address is 'Retrieve deposit address for currency';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_deposits_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_deposits_request as (
    "currency" deribit.private_get_deposits_request_currency,
    "count" bigint,
    "offset" bigint
);

comment on column deribit.private_get_deposits_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_deposits_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_deposits_request."offset" is 'The offset for pagination, default - 0';

create type deribit.private_get_deposits_response_datum as (
    "address" text,
    "amount" double precision,
    "currency" text,
    "received_timestamp" bigint,
    "state" text,
    "transaction_id" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_get_deposits_response_datum."address" is 'Address in proper format for currency';
comment on column deribit.private_get_deposits_response_datum."amount" is 'Amount of funds in given currency';
comment on column deribit.private_get_deposits_response_datum."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_deposits_response_datum."received_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_deposits_response_datum."state" is 'Deposit state, allowed values : pending, completed, rejected, replaced';
comment on column deribit.private_get_deposits_response_datum."transaction_id" is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_get_deposits_response_datum."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_deposits_response_result as (
    "count" bigint,
    "data" deribit.private_get_deposits_response_datum[]
);

comment on column deribit.private_get_deposits_response_result."count" is 'Total number of results available';

create type deribit.private_get_deposits_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_deposits_response_result
);

comment on column deribit.private_get_deposits_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_deposits_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_deposits(
    "currency" deribit.private_get_deposits_request_currency,
    "count" bigint default null,
    "offset" bigint default null
)
returns deribit.private_get_deposits_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "count",
            "offset"
        )::deribit.private_get_deposits_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_deposits'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_deposits_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_deposits is 'Retrieve the latest users deposits';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_email_language_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_get_email_language_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_email_language_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_email_language_response."result" is 'The abbreviation of the language';

create function deribit.private_get_email_language()
returns text
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_email_language'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_email_language_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_email_language is 'Retrieves the language to be used for emails.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_last_block_trades_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_last_block_trades_by_currency_request as (
    "currency" deribit.private_get_last_block_trades_by_currency_request_currency,
    "count" bigint,
    "start_id" text,
    "end_id" text
);

comment on column deribit.private_get_last_block_trades_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_last_block_trades_by_currency_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_last_block_trades_by_currency_request."start_id" is 'Response will contain block trades older than the one provided in this field';
comment on column deribit.private_get_last_block_trades_by_currency_request."end_id" is 'The id of the oldest block trade to be returned, start_id is required with end_id';

create type deribit.private_get_last_block_trades_by_currency_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_last_block_trades_by_currency_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."matching_id" is 'Always null';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."price" is 'Price in base currency';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_last_block_trades_by_currency_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_last_block_trades_by_currency_response_result as (
    "app_name" text,
    "id" text,
    "timestamp" bigint,
    "trades" deribit.private_get_last_block_trades_by_currency_response_trade[]
);

comment on column deribit.private_get_last_block_trades_by_currency_response_result."app_name" is 'The name of the application that executed the block trade on behalf of the user (optional).';
comment on column deribit.private_get_last_block_trades_by_currency_response_result."id" is 'Block trade id';
comment on column deribit.private_get_last_block_trades_by_currency_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_last_block_trades_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_last_block_trades_by_currency_response_result[]
);

comment on column deribit.private_get_last_block_trades_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_last_block_trades_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_last_block_trades_by_currency(
    "currency" deribit.private_get_last_block_trades_by_currency_request_currency,
    "count" bigint default null,
    "start_id" text default null,
    "end_id" text default null
)
returns setof deribit.private_get_last_block_trades_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "count",
            "start_id",
            "end_id"
        )::deribit.private_get_last_block_trades_by_currency_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_last_block_trades_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_last_block_trades_by_currency_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."app_name"::text,
        (b)."id"::text,
        (b)."timestamp"::bigint,
        (b)."trades"::deribit.private_get_last_block_trades_by_currency_response_trade[]
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_last_block_trades_by_currency is 'Returns list of last users block trades';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_margins_request as (
    "instrument_name" text,
    "amount" double precision,
    "price" double precision
);

comment on column deribit.private_get_margins_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_margins_request."amount" is '(Required) It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is the underlying base currency coin. For options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_margins_request."price" is '(Required) Price';

create type deribit.private_get_margins_response_result as (
    "buy" double precision,
    "max_price" double precision,
    "min_price" double precision,
    "sell" double precision
);

comment on column deribit.private_get_margins_response_result."buy" is 'Margin when buying';
comment on column deribit.private_get_margins_response_result."max_price" is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.private_get_margins_response_result."min_price" is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.private_get_margins_response_result."sell" is 'Margin when selling';

create type deribit.private_get_margins_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_margins_response_result
);

comment on column deribit.private_get_margins_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_margins_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_margins(
    "instrument_name" text,
    "amount" double precision,
    "price" double precision
)
returns deribit.private_get_margins_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "amount",
            "price"
        )::deribit.private_get_margins_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_margins'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_margins_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_margins is 'Get margins for a given instrument, amount and price.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_mmp_config_request_index_name as enum (
    'ada_usdc',
    'ada_usdt',
    'algo_usdc',
    'algo_usdt',
    'avax_usdc',
    'avax_usdt',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usdc',
    'doge_usdt',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usdc',
    'link_usdt',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usdc',
    'matic_usdt',
    'near_usdc',
    'near_usdt',
    'shib_usdc',
    'shib_usdt',
    'sol_usdc',
    'sol_usdt',
    'trx_usdc',
    'trx_usdt',
    'uni_usdc',
    'uni_usdt',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.private_get_mmp_config_request as (
    "index_name" deribit.private_get_mmp_config_request_index_name,
    "mmp_group" text
);

comment on column deribit.private_get_mmp_config_request."index_name" is 'Index identifier of derivative instrument on the platform; skipping this parameter will return all configurations';
comment on column deribit.private_get_mmp_config_request."mmp_group" is 'Specifies the MMP group for which the configuration is being retrieved. MMP groups are used for Mass Quotes. If MMP group is not provided, the endpoint returns the configuration for the MMP settings for regular orders. The index_name must be specified before using this parameter';

create type deribit.private_get_mmp_config_response_result as (
    "delta_limit" double precision,
    "frozen_time" bigint,
    "index_name" text,
    "interval" bigint,
    "mmp_group" text,
    "quantity_limit" double precision
);

comment on column deribit.private_get_mmp_config_response_result."delta_limit" is 'Delta limit';
comment on column deribit.private_get_mmp_config_response_result."frozen_time" is 'MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_get_mmp_config_response_result."index_name" is 'Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.private_get_mmp_config_response_result."interval" is 'MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_get_mmp_config_response_result."mmp_group" is 'Specified MMP Group';
comment on column deribit.private_get_mmp_config_response_result."quantity_limit" is 'Quantity limit';

create type deribit.private_get_mmp_config_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_mmp_config_response_result[]
);

comment on column deribit.private_get_mmp_config_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_mmp_config_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_mmp_config(
    "index_name" deribit.private_get_mmp_config_request_index_name default null,
    "mmp_group" text default null
)
returns setof deribit.private_get_mmp_config_response_result
language sql
as $$
    
    with request as (
        select row(
            "index_name",
            "mmp_group"
        )::deribit.private_get_mmp_config_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_mmp_config'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_mmp_config_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."delta_limit"::double precision,
        (b)."frozen_time"::bigint,
        (b)."index_name"::text,
        (b)."interval"::bigint,
        (b)."mmp_group"::text,
        (b)."quantity_limit"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_mmp_config is 'Get MMP configuration for an index, if the parameter is not provided, a list of all MMP configurations is returned. Empty list means no MMP configuration.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_new_announcements_response_result as (
    "body" text,
    "confirmation" boolean,
    "id" double precision,
    "important" boolean,
    "publication_timestamp" bigint,
    "title" text
);

comment on column deribit.private_get_new_announcements_response_result."body" is 'The HTML body of the announcement';
comment on column deribit.private_get_new_announcements_response_result."confirmation" is 'Whether the user confirmation is required for this announcement';
comment on column deribit.private_get_new_announcements_response_result."id" is 'A unique identifier for the announcement';
comment on column deribit.private_get_new_announcements_response_result."important" is 'Whether the announcement is marked as important';
comment on column deribit.private_get_new_announcements_response_result."publication_timestamp" is 'The timestamp (milliseconds since the Unix epoch) of announcement publication';
comment on column deribit.private_get_new_announcements_response_result."title" is 'The title of the announcement';

create type deribit.private_get_new_announcements_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_new_announcements_response_result[]
);

comment on column deribit.private_get_new_announcements_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_new_announcements_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_new_announcements()
returns setof deribit.private_get_new_announcements_response_result
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_new_announcements'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_new_announcements_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."body"::text,
        (b)."confirmation"::boolean,
        (b)."id"::double precision,
        (b)."important"::boolean,
        (b)."publication_timestamp"::bigint,
        (b)."title"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_new_announcements is 'Retrieves announcements that have not been marked read by the user.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_open_orders_request_kind as enum (
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_get_open_orders_request_type as enum (
    'all',
    'limit',
    'stop_all',
    'stop_limit',
    'stop_market',
    'take_all',
    'take_limit',
    'take_market',
    'trailing_all',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_get_open_orders_request as (
    "kind" deribit.private_get_open_orders_request_kind,
    "type" deribit.private_get_open_orders_request_type
);

comment on column deribit.private_get_open_orders_request."kind" is 'Instrument kind, if not provided instruments of all kinds are considered';
comment on column deribit.private_get_open_orders_request."type" is 'Order type, default - all';

create type deribit.private_get_open_orders_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_open_orders_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_open_orders_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_open_orders_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_open_orders_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_open_orders_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_open_orders_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_open_orders_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_open_orders_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_open_orders_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_open_orders_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_open_orders_response_result."api" is 'true if created with API';
comment on column deribit.private_get_open_orders_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_open_orders_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_open_orders_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_open_orders_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_open_orders_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_open_orders_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_open_orders_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_open_orders_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_open_orders_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_open_orders_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_open_orders_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_open_orders_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_open_orders_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_open_orders_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_open_orders_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_open_orders_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_open_orders_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_open_orders_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_open_orders_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_open_orders_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_open_orders_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_open_orders_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_open_orders_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_open_orders_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_open_orders_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_open_orders_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_open_orders_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_open_orders_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_open_orders_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_open_orders_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_open_orders_response_result[]
);

comment on column deribit.private_get_open_orders_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_open_orders_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_open_orders(
    "kind" deribit.private_get_open_orders_request_kind default null,
    "type" deribit.private_get_open_orders_request_type default null
)
returns setof deribit.private_get_open_orders_response_result
language sql
as $$
    
    with request as (
        select row(
            "kind",
            "type"
        )::deribit.private_get_open_orders_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_open_orders'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_open_orders_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_open_orders is 'Retrieves list of user''s open orders across many currencies.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_open_orders_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_open_orders_by_currency_request_kind as enum (
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_get_open_orders_by_currency_request_type as enum (
    'all',
    'limit',
    'stop_all',
    'stop_limit',
    'stop_market',
    'take_all',
    'take_limit',
    'take_market',
    'trailing_all',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_get_open_orders_by_currency_request as (
    "currency" deribit.private_get_open_orders_by_currency_request_currency,
    "kind" deribit.private_get_open_orders_by_currency_request_kind,
    "type" deribit.private_get_open_orders_by_currency_request_type
);

comment on column deribit.private_get_open_orders_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_open_orders_by_currency_request."kind" is 'Instrument kind, if not provided instruments of all kinds are considered';
comment on column deribit.private_get_open_orders_by_currency_request."type" is 'Order type, default - all';

create type deribit.private_get_open_orders_by_currency_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_open_orders_by_currency_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_open_orders_by_currency_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_open_orders_by_currency_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_currency_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_open_orders_by_currency_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_open_orders_by_currency_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_open_orders_by_currency_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_open_orders_by_currency_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_currency_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_open_orders_by_currency_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_open_orders_by_currency_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_open_orders_by_currency_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_open_orders_by_currency_response_result."api" is 'true if created with API';
comment on column deribit.private_get_open_orders_by_currency_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_open_orders_by_currency_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_open_orders_by_currency_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_open_orders_by_currency_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_currency_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_open_orders_by_currency_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_currency_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_open_orders_by_currency_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_open_orders_by_currency_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_open_orders_by_currency_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_open_orders_by_currency_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_open_orders_by_currency_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_currency_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_currency_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_currency_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_open_orders_by_currency_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_open_orders_by_currency_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_open_orders_by_currency_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_currency_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_open_orders_by_currency_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_open_orders_by_currency_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_open_orders_by_currency_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_open_orders_by_currency_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_open_orders_by_currency_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_currency_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_open_orders_by_currency_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_open_orders_by_currency_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_open_orders_by_currency_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_currency_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_open_orders_by_currency_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_open_orders_by_currency_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_open_orders_by_currency_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_currency_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_open_orders_by_currency_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_open_orders_by_currency_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_open_orders_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_open_orders_by_currency_response_result[]
);

comment on column deribit.private_get_open_orders_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_open_orders_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_open_orders_by_currency(
    "currency" deribit.private_get_open_orders_by_currency_request_currency,
    "kind" deribit.private_get_open_orders_by_currency_request_kind default null,
    "type" deribit.private_get_open_orders_by_currency_request_type default null
)
returns setof deribit.private_get_open_orders_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "type"
        )::deribit.private_get_open_orders_by_currency_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_open_orders_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_open_orders_by_currency_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_open_orders_by_currency is 'Retrieves list of user''s open orders.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_open_orders_by_instrument_request_type as enum (
    'all',
    'limit',
    'stop_all',
    'stop_limit',
    'stop_market',
    'take_all',
    'take_limit',
    'take_market',
    'trailing_all',
    'trailing_stop',
    'trigger_all'
);

create type deribit.private_get_open_orders_by_instrument_request as (
    "instrument_name" text,
    "type" deribit.private_get_open_orders_by_instrument_request_type
);

comment on column deribit.private_get_open_orders_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_open_orders_by_instrument_request."type" is 'Order type, default - all';

create type deribit.private_get_open_orders_by_instrument_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_open_orders_by_instrument_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_open_orders_by_instrument_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_open_orders_by_instrument_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."api" is 'true if created with API';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_open_orders_by_instrument_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_instrument_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_open_orders_by_instrument_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_open_orders_by_instrument_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_open_orders_by_instrument_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_open_orders_by_instrument_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_open_orders_by_instrument_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_open_orders_by_instrument_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_instrument_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_open_orders_by_instrument_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_open_orders_by_instrument_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_instrument_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_open_orders_by_instrument_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_open_orders_by_instrument_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_instrument_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_open_orders_by_instrument_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_open_orders_by_instrument_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_open_orders_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_open_orders_by_instrument_response_result[]
);

comment on column deribit.private_get_open_orders_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_open_orders_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_open_orders_by_instrument(
    "instrument_name" text,
    "type" deribit.private_get_open_orders_by_instrument_request_type default null
)
returns setof deribit.private_get_open_orders_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "type"
        )::deribit.private_get_open_orders_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_open_orders_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_open_orders_by_instrument_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_open_orders_by_instrument is 'Retrieves list of user''s open orders within a given Instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_open_orders_by_label_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_open_orders_by_label_request as (
    "currency" deribit.private_get_open_orders_by_label_request_currency,
    "label" text
);

comment on column deribit.private_get_open_orders_by_label_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_open_orders_by_label_request."label" is 'user defined label for the order (maximum 64 characters)';

create type deribit.private_get_open_orders_by_label_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_open_orders_by_label_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_open_orders_by_label_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_open_orders_by_label_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_label_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_open_orders_by_label_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_open_orders_by_label_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_open_orders_by_label_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_open_orders_by_label_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_label_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_open_orders_by_label_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_open_orders_by_label_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_open_orders_by_label_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_open_orders_by_label_response_result."api" is 'true if created with API';
comment on column deribit.private_get_open_orders_by_label_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_open_orders_by_label_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_open_orders_by_label_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_open_orders_by_label_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_open_orders_by_label_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_label_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_open_orders_by_label_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_open_orders_by_label_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_label_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_open_orders_by_label_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_open_orders_by_label_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_open_orders_by_label_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_open_orders_by_label_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_open_orders_by_label_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_label_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_open_orders_by_label_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_label_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_open_orders_by_label_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_open_orders_by_label_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_open_orders_by_label_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_open_orders_by_label_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_open_orders_by_label_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_open_orders_by_label_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_open_orders_by_label_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_open_orders_by_label_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_open_orders_by_label_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_open_orders_by_label_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_open_orders_by_label_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_open_orders_by_label_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_open_orders_by_label_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_open_orders_by_label_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_open_orders_by_label_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_open_orders_by_label_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_open_orders_by_label_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_open_orders_by_label_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_open_orders_by_label_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_open_orders_by_label_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_open_orders_by_label_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_open_orders_by_label_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_open_orders_by_label_response_result[]
);

comment on column deribit.private_get_open_orders_by_label_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_open_orders_by_label_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_open_orders_by_label(
    "currency" deribit.private_get_open_orders_by_label_request_currency,
    "label" text default null
)
returns setof deribit.private_get_open_orders_by_label_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "label"
        )::deribit.private_get_open_orders_by_label_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_open_orders_by_label'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_open_orders_by_label_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_open_orders_by_label is 'Retrieves list of user''s open orders for given currency and label.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_order_history_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_order_history_by_currency_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_get_order_history_by_currency_request as (
    "currency" deribit.private_get_order_history_by_currency_request_currency,
    "kind" deribit.private_get_order_history_by_currency_request_kind,
    "count" bigint,
    "offset" bigint,
    "include_old" boolean,
    "include_unfilled" boolean
);

comment on column deribit.private_get_order_history_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_order_history_by_currency_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_get_order_history_by_currency_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_order_history_by_currency_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.private_get_order_history_by_currency_request."include_old" is 'Include in result orders older than 2 days, default - false';
comment on column deribit.private_get_order_history_by_currency_request."include_unfilled" is 'Include in result fully unfilled closed orders, default - false';

create type deribit.private_get_order_history_by_currency_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_order_history_by_currency_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_order_history_by_currency_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_order_history_by_currency_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_history_by_currency_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_order_history_by_currency_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_order_history_by_currency_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_order_history_by_currency_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_order_history_by_currency_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_order_history_by_currency_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_order_history_by_currency_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_order_history_by_currency_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_order_history_by_currency_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_order_history_by_currency_response_result."api" is 'true if created with API';
comment on column deribit.private_get_order_history_by_currency_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_order_history_by_currency_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_order_history_by_currency_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_order_history_by_currency_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_order_history_by_currency_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_history_by_currency_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_order_history_by_currency_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_order_history_by_currency_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_history_by_currency_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_order_history_by_currency_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_order_history_by_currency_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_order_history_by_currency_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_order_history_by_currency_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_order_history_by_currency_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_history_by_currency_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_order_history_by_currency_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_history_by_currency_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_order_history_by_currency_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_order_history_by_currency_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_order_history_by_currency_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_history_by_currency_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_order_history_by_currency_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_order_history_by_currency_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_order_history_by_currency_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_order_history_by_currency_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_order_history_by_currency_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_history_by_currency_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_order_history_by_currency_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_order_history_by_currency_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_order_history_by_currency_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_order_history_by_currency_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_history_by_currency_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_order_history_by_currency_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_order_history_by_currency_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_order_history_by_currency_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_history_by_currency_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_order_history_by_currency_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_order_history_by_currency_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_order_history_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_order_history_by_currency_response_result[]
);

comment on column deribit.private_get_order_history_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_order_history_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_order_history_by_currency(
    "currency" deribit.private_get_order_history_by_currency_request_currency,
    "kind" deribit.private_get_order_history_by_currency_request_kind default null,
    "count" bigint default null,
    "offset" bigint default null,
    "include_old" boolean default null,
    "include_unfilled" boolean default null
)
returns setof deribit.private_get_order_history_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "count",
            "offset",
            "include_old",
            "include_unfilled"
        )::deribit.private_get_order_history_by_currency_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_order_history_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_order_history_by_currency_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_order_history_by_currency is 'Retrieves history of orders that have been partially or fully filled.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_order_history_by_instrument_request as (
    "instrument_name" text,
    "count" bigint,
    "offset" bigint,
    "include_old" boolean,
    "include_unfilled" boolean
);

comment on column deribit.private_get_order_history_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_order_history_by_instrument_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_order_history_by_instrument_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.private_get_order_history_by_instrument_request."include_old" is 'Include in result orders older than 2 days, default - false';
comment on column deribit.private_get_order_history_by_instrument_request."include_unfilled" is 'Include in result fully unfilled closed orders, default - false';

create type deribit.private_get_order_history_by_instrument_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_order_history_by_instrument_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_order_history_by_instrument_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_order_history_by_instrument_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_history_by_instrument_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_order_history_by_instrument_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_order_history_by_instrument_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_order_history_by_instrument_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_order_history_by_instrument_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_order_history_by_instrument_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_order_history_by_instrument_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_order_history_by_instrument_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_order_history_by_instrument_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_order_history_by_instrument_response_result."api" is 'true if created with API';
comment on column deribit.private_get_order_history_by_instrument_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_order_history_by_instrument_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_order_history_by_instrument_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_order_history_by_instrument_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_order_history_by_instrument_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_history_by_instrument_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_order_history_by_instrument_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_order_history_by_instrument_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_history_by_instrument_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_order_history_by_instrument_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_order_history_by_instrument_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_order_history_by_instrument_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_order_history_by_instrument_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_order_history_by_instrument_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_history_by_instrument_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_order_history_by_instrument_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_history_by_instrument_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_order_history_by_instrument_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_order_history_by_instrument_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_order_history_by_instrument_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_history_by_instrument_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_order_history_by_instrument_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_order_history_by_instrument_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_order_history_by_instrument_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_order_history_by_instrument_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_order_history_by_instrument_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_history_by_instrument_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_order_history_by_instrument_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_order_history_by_instrument_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_order_history_by_instrument_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_order_history_by_instrument_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_history_by_instrument_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_order_history_by_instrument_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_order_history_by_instrument_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_order_history_by_instrument_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_history_by_instrument_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_order_history_by_instrument_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_order_history_by_instrument_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_order_history_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_order_history_by_instrument_response_result[]
);

comment on column deribit.private_get_order_history_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_order_history_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_order_history_by_instrument(
    "instrument_name" text,
    "count" bigint default null,
    "offset" bigint default null,
    "include_old" boolean default null,
    "include_unfilled" boolean default null
)
returns setof deribit.private_get_order_history_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "count",
            "offset",
            "include_old",
            "include_unfilled"
        )::deribit.private_get_order_history_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_order_history_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_order_history_by_instrument_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_order_history_by_instrument is 'Retrieves history of orders that have been partially or fully filled.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_order_margin_by_ids_request as (
    "ids" text[]
);

comment on column deribit.private_get_order_margin_by_ids_request."ids" is '(Required) Ids of orders';

create type deribit.private_get_order_margin_by_ids_response_result as (
    "initial_margin" double precision,
    "initial_margin_currency" text,
    "order_id" text
);

comment on column deribit.private_get_order_margin_by_ids_response_result."initial_margin" is 'Initial margin of order';
comment on column deribit.private_get_order_margin_by_ids_response_result."initial_margin_currency" is 'Currency of initial margin';
comment on column deribit.private_get_order_margin_by_ids_response_result."order_id" is 'Unique order identifier';

create type deribit.private_get_order_margin_by_ids_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_order_margin_by_ids_response_result[]
);

comment on column deribit.private_get_order_margin_by_ids_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_order_margin_by_ids_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_order_margin_by_ids(
    "ids" text[]
)
returns setof deribit.private_get_order_margin_by_ids_response_result
language sql
as $$
    
    with request as (
        select row(
            "ids"
        )::deribit.private_get_order_margin_by_ids_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_order_margin_by_ids'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_order_margin_by_ids_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."initial_margin"::double precision,
        (b)."initial_margin_currency"::text,
        (b)."order_id"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_order_margin_by_ids is 'Retrieves initial margins of given orders';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_order_state_request as (
    "order_id" text
);

comment on column deribit.private_get_order_state_request."order_id" is '(Required) The order id';

create type deribit.private_get_order_state_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_order_state_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_order_state_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_order_state_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_state_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_order_state_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_order_state_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_order_state_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_order_state_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_order_state_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_order_state_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_order_state_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_order_state_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_order_state_response_result."api" is 'true if created with API';
comment on column deribit.private_get_order_state_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_order_state_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_order_state_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_order_state_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_order_state_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_state_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_order_state_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_order_state_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_state_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_order_state_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_order_state_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_order_state_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_order_state_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_order_state_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_state_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_order_state_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_state_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_order_state_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_order_state_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_order_state_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_state_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_order_state_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_order_state_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_order_state_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_order_state_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_order_state_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_state_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_order_state_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_order_state_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_order_state_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_order_state_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_state_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_order_state_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_order_state_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_order_state_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_state_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_order_state_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_order_state_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_order_state_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_order_state_response_result
);

comment on column deribit.private_get_order_state_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_order_state_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_order_state(
    "order_id" text
)
returns deribit.private_get_order_state_response_result
language sql
as $$
    
    with request as (
        select row(
            "order_id"
        )::deribit.private_get_order_state_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_order_state'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_order_state_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_order_state is 'Retrieve the current state of an order.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_order_state_by_label_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_order_state_by_label_request as (
    "currency" deribit.private_get_order_state_by_label_request_currency,
    "label" text
);

comment on column deribit.private_get_order_state_by_label_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_order_state_by_label_request."label" is 'user defined label for the order (maximum 64 characters)';

create type deribit.private_get_order_state_by_label_response_result as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_order_state_by_label_response_result."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_order_state_by_label_response_result."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_order_state_by_label_response_result."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_state_by_label_response_result."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_order_state_by_label_response_result."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_order_state_by_label_response_result."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_order_state_by_label_response_result."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_order_state_by_label_response_result."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_order_state_by_label_response_result."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_order_state_by_label_response_result."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_order_state_by_label_response_result."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_order_state_by_label_response_result."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_order_state_by_label_response_result."api" is 'true if created with API';
comment on column deribit.private_get_order_state_by_label_response_result."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_order_state_by_label_response_result."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_order_state_by_label_response_result."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_order_state_by_label_response_result."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_order_state_by_label_response_result."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_state_by_label_response_result."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_order_state_by_label_response_result."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_order_state_by_label_response_result."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_state_by_label_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_order_state_by_label_response_result."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_order_state_by_label_response_result."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_order_state_by_label_response_result."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_order_state_by_label_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_order_state_by_label_response_result."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_state_by_label_response_result."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_order_state_by_label_response_result."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_state_by_label_response_result."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_order_state_by_label_response_result."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_order_state_by_label_response_result."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_order_state_by_label_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_order_state_by_label_response_result."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_order_state_by_label_response_result."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_order_state_by_label_response_result."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_order_state_by_label_response_result."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_order_state_by_label_response_result."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_order_state_by_label_response_result."order_id" is 'Unique order identifier';
comment on column deribit.private_get_order_state_by_label_response_result."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_order_state_by_label_response_result."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_order_state_by_label_response_result."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_order_state_by_label_response_result."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_order_state_by_label_response_result."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_order_state_by_label_response_result."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_order_state_by_label_response_result."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_order_state_by_label_response_result."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_order_state_by_label_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_order_state_by_label_response_result."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_order_state_by_label_response_result."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_order_state_by_label_response_result."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_order_state_by_label_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_order_state_by_label_response_result[]
);

comment on column deribit.private_get_order_state_by_label_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_order_state_by_label_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_order_state_by_label(
    "currency" deribit.private_get_order_state_by_label_request_currency,
    "label" text default null
)
returns setof deribit.private_get_order_state_by_label_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "label"
        )::deribit.private_get_order_state_by_label_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_order_state_by_label'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_order_state_by_label_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."reject_post_only"::boolean,
        (b)."label"::text,
        (b)."quote_id"::text,
        (b)."order_state"::text,
        (b)."is_secondary_oto"::boolean,
        (b)."usd"::double precision,
        (b)."implv"::double precision,
        (b)."trigger_reference_price"::double precision,
        (b)."original_order_type"::text,
        (b)."oco_ref"::text,
        (b)."block_trade"::boolean,
        (b)."trigger_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."oto_order_ids"::text[],
        (b)."trigger_order_id"::text,
        (b)."cancel_reason"::text,
        (b)."primary_order_id"::text,
        (b)."quote"::boolean,
        (b)."risk_reducing"::boolean,
        (b)."filled_amount"::double precision,
        (b)."instrument_name"::text,
        (b)."max_show"::double precision,
        (b)."app_name"::text,
        (b)."mmp_cancelled"::boolean,
        (b)."direction"::text,
        (b)."last_update_timestamp"::bigint,
        (b)."trigger_offset"::double precision,
        (b)."mmp_group"::text,
        (b)."price"::text,
        (b)."is_liquidation"::boolean,
        (b)."reduce_only"::boolean,
        (b)."amount"::double precision,
        (b)."is_primary_otoco"::boolean,
        (b)."post_only"::boolean,
        (b)."mobile"::boolean,
        (b)."trigger_fill_condition"::text,
        (b)."triggered"::boolean,
        (b)."order_id"::text,
        (b)."replaced"::boolean,
        (b)."order_type"::text,
        (b)."time_in_force"::text,
        (b)."auto_replaced"::boolean,
        (b)."quote_set_id"::text,
        (b)."contracts"::double precision,
        (b)."trigger"::text,
        (b)."web"::boolean,
        (b)."creation_timestamp"::bigint,
        (b)."is_rebalance"::boolean,
        (b)."average_price"::double precision,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_order_state_by_label is 'Retrieve the state of recent orders with a given label.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_pending_block_trades_response_trade as (
    "amount" double precision,
    "direction" text,
    "instrument_name" text,
    "price" double precision
);

comment on column deribit.private_get_pending_block_trades_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_pending_block_trades_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_pending_block_trades_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_pending_block_trades_response_trade."price" is 'Price in base currency';

create type deribit.private_get_pending_block_trades_response_state as (
    "timestamp" bigint,
    "value" text
);

comment on column deribit.private_get_pending_block_trades_response_state."timestamp" is 'State timestamp.';
comment on column deribit.private_get_pending_block_trades_response_state."value" is 'State value.';

create type deribit.private_get_pending_block_trades_response_counterparty_state as (
    "timestamp" bigint,
    "value" text
);

comment on column deribit.private_get_pending_block_trades_response_counterparty_state."timestamp" is 'State timestamp.';
comment on column deribit.private_get_pending_block_trades_response_counterparty_state."value" is 'State value.';

create type deribit.private_get_pending_block_trades_response_result as (
    "app_name" text,
    "counterparty_state" deribit.private_get_pending_block_trades_response_counterparty_state,
    "nonce" text,
    "role" text,
    "state" deribit.private_get_pending_block_trades_response_state,
    "timestamp" bigint,
    "trades" deribit.private_get_pending_block_trades_response_trade[],
    "user_id" bigint
);

comment on column deribit.private_get_pending_block_trades_response_result."app_name" is 'The name of the application that executed the block trade on behalf of the user (optional).';
comment on column deribit.private_get_pending_block_trades_response_result."counterparty_state" is 'State of the pending block trade for the other party (optional).';
comment on column deribit.private_get_pending_block_trades_response_result."nonce" is 'Nonce that can be used to approve or reject pending block trade.';
comment on column deribit.private_get_pending_block_trades_response_result."role" is 'Trade role of the user: maker or taker';
comment on column deribit.private_get_pending_block_trades_response_result."state" is 'State of the pending block trade for current user.';
comment on column deribit.private_get_pending_block_trades_response_result."timestamp" is 'Timestamp that can be used to approve or reject pending block trade.';
comment on column deribit.private_get_pending_block_trades_response_result."user_id" is 'Unique user identifier';

create type deribit.private_get_pending_block_trades_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_pending_block_trades_response_result[]
);

comment on column deribit.private_get_pending_block_trades_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_pending_block_trades_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_pending_block_trades()
returns setof deribit.private_get_pending_block_trades_response_result
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_pending_block_trades'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_pending_block_trades_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."app_name"::text,
        (b)."counterparty_state"::deribit.private_get_pending_block_trades_response_counterparty_state,
        (b)."nonce"::text,
        (b)."role"::text,
        (b)."state"::deribit.private_get_pending_block_trades_response_state,
        (b)."timestamp"::bigint,
        (b)."trades"::deribit.private_get_pending_block_trades_response_trade[],
        (b)."user_id"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_pending_block_trades is 'Provides a list of pending block trade approvals. timestamp and nonce received in response can be used to approve or reject the pending block trade. To use a block trade approval feature the additional API key setting feature called: enabled_features: block_trade_approval is required. This key has to be given to broker/registered partner who performs the trades on behalf of the user for the feature to be active. If the user wants to approve the trade, he has to approve it from different API key with doesn''t have this feature enabled.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_position_request as (
    "instrument_name" text
);

comment on column deribit.private_get_position_request."instrument_name" is '(Required) Instrument name';

create type deribit.private_get_position_response_result as (
    "average_price" double precision,
    "average_price_usd" double precision,
    "delta" double precision,
    "direction" text,
    "estimated_liquidation_price" double precision,
    "floating_profit_loss" double precision,
    "floating_profit_loss_usd" double precision,
    "gamma" double precision,
    "index_price" double precision,
    "initial_margin" double precision,
    "instrument_name" text,
    "interest_value" double precision,
    "kind" text,
    "leverage" bigint,
    "maintenance_margin" double precision,
    "mark_price" double precision,
    "open_orders_margin" double precision,
    "realized_funding" double precision,
    "realized_profit_loss" double precision,
    "settlement_price" double precision,
    "size" double precision,
    "size_currency" double precision,
    "theta" double precision,
    "total_profit_loss" double precision,
    "vega" double precision
);

comment on column deribit.private_get_position_response_result."average_price" is 'Average price of trades that built this position';
comment on column deribit.private_get_position_response_result."average_price_usd" is 'Only for options, average price in USD';
comment on column deribit.private_get_position_response_result."delta" is 'Delta parameter';
comment on column deribit.private_get_position_response_result."direction" is 'Direction: buy, sell or zero';
comment on column deribit.private_get_position_response_result."estimated_liquidation_price" is 'Estimated liquidation price, added only for futures, for non portfolio margining users';
comment on column deribit.private_get_position_response_result."floating_profit_loss" is 'Floating profit or loss';
comment on column deribit.private_get_position_response_result."floating_profit_loss_usd" is 'Only for options, floating profit or loss in USD';
comment on column deribit.private_get_position_response_result."gamma" is 'Only for options, Gamma parameter';
comment on column deribit.private_get_position_response_result."index_price" is 'Current index price';
comment on column deribit.private_get_position_response_result."initial_margin" is 'Initial margin';
comment on column deribit.private_get_position_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_position_response_result."interest_value" is 'Value used to calculate realized_funding (perpetual only)';
comment on column deribit.private_get_position_response_result."kind" is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.private_get_position_response_result."leverage" is 'Current available leverage for future position';
comment on column deribit.private_get_position_response_result."maintenance_margin" is 'Maintenance margin';
comment on column deribit.private_get_position_response_result."mark_price" is 'Current mark price for position''s instrument';
comment on column deribit.private_get_position_response_result."open_orders_margin" is 'Open orders margin';
comment on column deribit.private_get_position_response_result."realized_funding" is 'Realized Funding in current session included in session realized profit or loss, only for positions of perpetual instruments';
comment on column deribit.private_get_position_response_result."realized_profit_loss" is 'Realized profit or loss';
comment on column deribit.private_get_position_response_result."settlement_price" is 'Optional (not added for spot). Last settlement price for position''s instrument 0 if instrument wasn''t settled yet';
comment on column deribit.private_get_position_response_result."size" is 'Position size for futures size in quote currency (e.g. USD), for options size is in base currency (e.g. BTC)';
comment on column deribit.private_get_position_response_result."size_currency" is 'Only for futures, position size in base currency';
comment on column deribit.private_get_position_response_result."theta" is 'Only for options, Theta parameter';
comment on column deribit.private_get_position_response_result."total_profit_loss" is 'Profit or loss from position';
comment on column deribit.private_get_position_response_result."vega" is 'Only for options, Vega parameter';

create type deribit.private_get_position_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_position_response_result
);

comment on column deribit.private_get_position_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_position_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_position(
    "instrument_name" text
)
returns deribit.private_get_position_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name"
        )::deribit.private_get_position_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_position'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_position_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_position is 'Retrieve user position.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_positions_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT',
    'any'
);

create type deribit.private_get_positions_request_kind as enum (
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_get_positions_request as (
    "currency" deribit.private_get_positions_request_currency,
    "kind" deribit.private_get_positions_request_kind,
    "subaccount_id" bigint
);

comment on column deribit.private_get_positions_request."currency" is 'nan';
comment on column deribit.private_get_positions_request."kind" is 'Kind filter on positions';
comment on column deribit.private_get_positions_request."subaccount_id" is 'The user id for the subaccount';

create type deribit.private_get_positions_response_result as (
    "average_price" double precision,
    "average_price_usd" double precision,
    "delta" double precision,
    "direction" text,
    "estimated_liquidation_price" double precision,
    "floating_profit_loss" double precision,
    "floating_profit_loss_usd" double precision,
    "gamma" double precision,
    "index_price" double precision,
    "initial_margin" double precision,
    "instrument_name" text,
    "interest_value" double precision,
    "kind" text,
    "leverage" bigint,
    "maintenance_margin" double precision,
    "mark_price" double precision,
    "open_orders_margin" double precision,
    "realized_funding" double precision,
    "realized_profit_loss" double precision,
    "settlement_price" double precision,
    "size" double precision,
    "size_currency" double precision,
    "theta" double precision,
    "total_profit_loss" double precision,
    "vega" double precision
);

comment on column deribit.private_get_positions_response_result."average_price" is 'Average price of trades that built this position';
comment on column deribit.private_get_positions_response_result."average_price_usd" is 'Only for options, average price in USD';
comment on column deribit.private_get_positions_response_result."delta" is 'Delta parameter';
comment on column deribit.private_get_positions_response_result."direction" is 'Direction: buy, sell or zero';
comment on column deribit.private_get_positions_response_result."estimated_liquidation_price" is 'Estimated liquidation price, added only for futures, for non portfolio margining users';
comment on column deribit.private_get_positions_response_result."floating_profit_loss" is 'Floating profit or loss';
comment on column deribit.private_get_positions_response_result."floating_profit_loss_usd" is 'Only for options, floating profit or loss in USD';
comment on column deribit.private_get_positions_response_result."gamma" is 'Only for options, Gamma parameter';
comment on column deribit.private_get_positions_response_result."index_price" is 'Current index price';
comment on column deribit.private_get_positions_response_result."initial_margin" is 'Initial margin';
comment on column deribit.private_get_positions_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_positions_response_result."interest_value" is 'Value used to calculate realized_funding (perpetual only)';
comment on column deribit.private_get_positions_response_result."kind" is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.private_get_positions_response_result."leverage" is 'Current available leverage for future position';
comment on column deribit.private_get_positions_response_result."maintenance_margin" is 'Maintenance margin';
comment on column deribit.private_get_positions_response_result."mark_price" is 'Current mark price for position''s instrument';
comment on column deribit.private_get_positions_response_result."open_orders_margin" is 'Open orders margin';
comment on column deribit.private_get_positions_response_result."realized_funding" is 'Realized Funding in current session included in session realized profit or loss, only for positions of perpetual instruments';
comment on column deribit.private_get_positions_response_result."realized_profit_loss" is 'Realized profit or loss';
comment on column deribit.private_get_positions_response_result."settlement_price" is 'Optional (not added for spot). Last settlement price for position''s instrument 0 if instrument wasn''t settled yet';
comment on column deribit.private_get_positions_response_result."size" is 'Position size for futures size in quote currency (e.g. USD), for options size is in base currency (e.g. BTC)';
comment on column deribit.private_get_positions_response_result."size_currency" is 'Only for futures, position size in base currency';
comment on column deribit.private_get_positions_response_result."theta" is 'Only for options, Theta parameter';
comment on column deribit.private_get_positions_response_result."total_profit_loss" is 'Profit or loss from position';
comment on column deribit.private_get_positions_response_result."vega" is 'Only for options, Vega parameter';

create type deribit.private_get_positions_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_positions_response_result[]
);

comment on column deribit.private_get_positions_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_positions_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_positions(
    "currency" deribit.private_get_positions_request_currency default null,
    "kind" deribit.private_get_positions_request_kind default null,
    "subaccount_id" bigint default null
)
returns setof deribit.private_get_positions_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "subaccount_id"
        )::deribit.private_get_positions_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_positions'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_positions_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."average_price"::double precision,
        (b)."average_price_usd"::double precision,
        (b)."delta"::double precision,
        (b)."direction"::text,
        (b)."estimated_liquidation_price"::double precision,
        (b)."floating_profit_loss"::double precision,
        (b)."floating_profit_loss_usd"::double precision,
        (b)."gamma"::double precision,
        (b)."index_price"::double precision,
        (b)."initial_margin"::double precision,
        (b)."instrument_name"::text,
        (b)."interest_value"::double precision,
        (b)."kind"::text,
        (b)."leverage"::bigint,
        (b)."maintenance_margin"::double precision,
        (b)."mark_price"::double precision,
        (b)."open_orders_margin"::double precision,
        (b)."realized_funding"::double precision,
        (b)."realized_profit_loss"::double precision,
        (b)."settlement_price"::double precision,
        (b)."size"::double precision,
        (b)."size_currency"::double precision,
        (b)."theta"::double precision,
        (b)."total_profit_loss"::double precision,
        (b)."vega"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_positions is 'Retrieve user positions. To retrieve subaccount positions, use subaccount_id parameter.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_settlement_history_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_settlement_history_by_currency_request_type as enum (
    'bankruptcy',
    'delivery',
    'settlement'
);

create type deribit.private_get_settlement_history_by_currency_request as (
    "currency" deribit.private_get_settlement_history_by_currency_request_currency,
    "type" deribit.private_get_settlement_history_by_currency_request_type,
    "count" bigint,
    "continuation" text,
    "search_start_timestamp" bigint
);

comment on column deribit.private_get_settlement_history_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_settlement_history_by_currency_request."type" is 'Settlement type';
comment on column deribit.private_get_settlement_history_by_currency_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_settlement_history_by_currency_request."continuation" is 'Continuation token for pagination';
comment on column deribit.private_get_settlement_history_by_currency_request."search_start_timestamp" is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.private_get_settlement_history_by_currency_response_settlement as (
    "funded" double precision,
    "funding" double precision,
    "index_price" double precision,
    "instrument_name" text,
    "mark_price" double precision,
    "position" double precision,
    "profit_loss" double precision,
    "session_bankruptcy" double precision,
    "session_profit_loss" double precision,
    "session_tax" double precision,
    "session_tax_rate" double precision,
    "socialized" double precision,
    "timestamp" bigint,
    "type" text
);

comment on column deribit.private_get_settlement_history_by_currency_response_settlement."funded" is 'funded amount (bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."funding" is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."index_price" is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."instrument_name" is 'instrument name (settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."mark_price" is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."position" is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."profit_loss" is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."session_bankruptcy" is 'value of session bankruptcy (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."session_profit_loss" is 'total value of session profit and losses (in base currency)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."session_tax" is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."session_tax_rate" is 'rate of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."socialized" is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_settlement_history_by_currency_response_settlement."type" is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.private_get_settlement_history_by_currency_response_result as (
    "continuation" text,
    "settlements" deribit.private_get_settlement_history_by_currency_response_settlement[]
);

comment on column deribit.private_get_settlement_history_by_currency_response_result."continuation" is 'Continuation token for pagination.';

create type deribit.private_get_settlement_history_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_settlement_history_by_currency_response_result
);

comment on column deribit.private_get_settlement_history_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_settlement_history_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_settlement_history_by_currency(
    "currency" deribit.private_get_settlement_history_by_currency_request_currency,
    "type" deribit.private_get_settlement_history_by_currency_request_type default null,
    "count" bigint default null,
    "continuation" text default null,
    "search_start_timestamp" bigint default null
)
returns deribit.private_get_settlement_history_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "type",
            "count",
            "continuation",
            "search_start_timestamp"
        )::deribit.private_get_settlement_history_by_currency_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_settlement_history_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_settlement_history_by_currency_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_settlement_history_by_currency is 'Retrieves settlement, delivery and bankruptcy events that have affected your account.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_settlement_history_by_instrument_request_type as enum (
    'bankruptcy',
    'delivery',
    'settlement'
);

create type deribit.private_get_settlement_history_by_instrument_request as (
    "instrument_name" text,
    "type" deribit.private_get_settlement_history_by_instrument_request_type,
    "count" bigint,
    "continuation" text,
    "search_start_timestamp" bigint
);

comment on column deribit.private_get_settlement_history_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_settlement_history_by_instrument_request."type" is 'Settlement type';
comment on column deribit.private_get_settlement_history_by_instrument_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_settlement_history_by_instrument_request."continuation" is 'Continuation token for pagination';
comment on column deribit.private_get_settlement_history_by_instrument_request."search_start_timestamp" is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.private_get_settlement_history_by_instrument_response_settlement as (
    "funded" double precision,
    "funding" double precision,
    "index_price" double precision,
    "instrument_name" text,
    "mark_price" double precision,
    "position" double precision,
    "profit_loss" double precision,
    "session_bankruptcy" double precision,
    "session_profit_loss" double precision,
    "session_tax" double precision,
    "session_tax_rate" double precision,
    "socialized" double precision,
    "timestamp" bigint,
    "type" text
);

comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."funded" is 'funded amount (bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."funding" is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."index_price" is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."instrument_name" is 'instrument name (settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."mark_price" is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."position" is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."profit_loss" is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."session_bankruptcy" is 'value of session bankruptcy (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."session_profit_loss" is 'total value of session profit and losses (in base currency)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."session_tax" is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."session_tax_rate" is 'rate of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."socialized" is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_settlement_history_by_instrument_response_settlement."type" is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.private_get_settlement_history_by_instrument_response_result as (
    "continuation" text,
    "settlements" deribit.private_get_settlement_history_by_instrument_response_settlement[]
);

comment on column deribit.private_get_settlement_history_by_instrument_response_result."continuation" is 'Continuation token for pagination.';

create type deribit.private_get_settlement_history_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_settlement_history_by_instrument_response_result
);

comment on column deribit.private_get_settlement_history_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_settlement_history_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_settlement_history_by_instrument(
    "instrument_name" text,
    "type" deribit.private_get_settlement_history_by_instrument_request_type default null,
    "count" bigint default null,
    "continuation" text default null,
    "search_start_timestamp" bigint default null
)
returns deribit.private_get_settlement_history_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "type",
            "count",
            "continuation",
            "search_start_timestamp"
        )::deribit.private_get_settlement_history_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_settlement_history_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_settlement_history_by_instrument_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_settlement_history_by_instrument is 'Retrieves public settlement, delivery and bankruptcy events filtered by instrument name';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_subaccounts_request as (
    "with_portfolio" boolean
);

comment on column deribit.private_get_subaccounts_request."with_portfolio" is 'Portfolio flag: true for portfolio information, false for subaccount information only. false by default';

create type deribit.private_get_subaccounts_response_eth as (
    "additional_reserve" double precision,
    "available_funds" double precision,
    "available_withdrawal_funds" double precision,
    "balance" double precision,
    "currency" text,
    "equity" double precision,
    "initial_margin" double precision,
    "maintenance_margin" double precision,
    "margin_balance" double precision,
    "spot_reserve" double precision
);

comment on column deribit.private_get_subaccounts_response_eth."additional_reserve" is 'The account''s balance reserved in other orders';

create type deribit.private_get_subaccounts_response_btc as (
    "additional_reserve" double precision,
    "available_funds" double precision,
    "available_withdrawal_funds" double precision,
    "balance" double precision,
    "currency" text,
    "equity" double precision,
    "initial_margin" double precision,
    "maintenance_margin" double precision,
    "margin_balance" double precision,
    "spot_reserve" double precision
);

comment on column deribit.private_get_subaccounts_response_btc."additional_reserve" is 'The account''s balance reserved in other orders';

create type deribit.private_get_subaccounts_response_portfolio as (
    "btc" deribit.private_get_subaccounts_response_btc,
    "eth" deribit.private_get_subaccounts_response_eth,
    "proof_id" text,
    "proof_id_signature" text,
    "receive_notifications" boolean,
    "security_keys_assignments" text[],
    "security_keys_enabled" boolean,
    "system_name" text,
    "type" text,
    "username" text
);

comment on column deribit.private_get_subaccounts_response_portfolio."proof_id" is 'hashed identifier used in the Proof Of Liability for the subaccount. This identifier allows you to find your entries in the Deribit Proof-Of-Reserves files. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_portfolio."proof_id_signature" is 'signature used as a base string for proof_id hash. IMPORTANT: Keep it secret to not disclose your entries in the Proof-Of-Reserves.';
comment on column deribit.private_get_subaccounts_response_portfolio."receive_notifications" is 'When true - receive all notification emails on the main email';
comment on column deribit.private_get_subaccounts_response_portfolio."security_keys_assignments" is 'Names of assignments with Security Keys assigned';
comment on column deribit.private_get_subaccounts_response_portfolio."security_keys_enabled" is 'Whether the Security Keys authentication is enabled';
comment on column deribit.private_get_subaccounts_response_portfolio."system_name" is 'System generated user nickname';

create type deribit.private_get_subaccounts_response_result as (
    "email" text,
    "id" bigint,
    "is_password" boolean,
    "login_enabled" boolean,
    "margin_model" text,
    "not_confirmed_email" text,
    "portfolio" deribit.private_get_subaccounts_response_portfolio
);

comment on column deribit.private_get_subaccounts_response_result."email" is 'User email';
comment on column deribit.private_get_subaccounts_response_result."id" is 'Account/Subaccount identifier';
comment on column deribit.private_get_subaccounts_response_result."is_password" is 'true when password for the subaccount has been configured';
comment on column deribit.private_get_subaccounts_response_result."login_enabled" is 'Informs whether login to the subaccount is enabled';
comment on column deribit.private_get_subaccounts_response_result."margin_model" is 'Margin model';
comment on column deribit.private_get_subaccounts_response_result."not_confirmed_email" is 'New email address that has not yet been confirmed. This field is only included if with_portfolio == true.';

create type deribit.private_get_subaccounts_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_subaccounts_response_result[]
);

comment on column deribit.private_get_subaccounts_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_subaccounts_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_subaccounts(
    "with_portfolio" boolean default null
)
returns setof deribit.private_get_subaccounts_response_result
language sql
as $$
    
    with request as (
        select row(
            "with_portfolio"
        )::deribit.private_get_subaccounts_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_subaccounts'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_subaccounts_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."email"::text,
        (b)."id"::bigint,
        (b)."is_password"::boolean,
        (b)."login_enabled"::boolean,
        (b)."margin_model"::text,
        (b)."not_confirmed_email"::text,
        (b)."portfolio"::deribit.private_get_subaccounts_response_portfolio
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_subaccounts is 'Get information about subaccounts. When called from subaccount, the response will include limited details for the main account and details for the subaccount initiating the request. The portfolio information will be included in the response only if the with_portfolio parameter is set to true.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_subaccounts_details_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_subaccounts_details_request as (
    "currency" deribit.private_get_subaccounts_details_request_currency,
    "with_open_orders" boolean
);

comment on column deribit.private_get_subaccounts_details_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_subaccounts_details_request."with_open_orders" is 'Optional parameter to ask for open orders list, default: false';

create type deribit.private_get_subaccounts_details_response_position as (
    "average_price" double precision,
    "average_price_usd" double precision,
    "delta" double precision,
    "direction" text,
    "floating_profit_loss" double precision,
    "floating_profit_loss_usd" double precision,
    "gamma" double precision,
    "index_price" double precision,
    "initial_margin" double precision,
    "instrument_name" text,
    "interest_value" double precision,
    "kind" text,
    "leverage" bigint,
    "maintenance_margin" double precision,
    "mark_price" double precision,
    "realized_funding" double precision,
    "realized_profit_loss" double precision,
    "settlement_price" double precision,
    "size" double precision,
    "size_currency" double precision,
    "theta" double precision,
    "total_profit_loss" double precision,
    "vega" double precision
);

comment on column deribit.private_get_subaccounts_details_response_position."average_price" is 'Average price of trades that built this position';
comment on column deribit.private_get_subaccounts_details_response_position."average_price_usd" is 'Only for options, average price in USD';
comment on column deribit.private_get_subaccounts_details_response_position."delta" is 'Delta parameter';
comment on column deribit.private_get_subaccounts_details_response_position."direction" is 'Direction: buy, sell or zero';
comment on column deribit.private_get_subaccounts_details_response_position."floating_profit_loss" is 'Floating profit or loss';
comment on column deribit.private_get_subaccounts_details_response_position."floating_profit_loss_usd" is 'Only for options, floating profit or loss in USD';
comment on column deribit.private_get_subaccounts_details_response_position."gamma" is 'Only for options, Gamma parameter';
comment on column deribit.private_get_subaccounts_details_response_position."index_price" is 'Current index price';
comment on column deribit.private_get_subaccounts_details_response_position."initial_margin" is 'Initial margin';
comment on column deribit.private_get_subaccounts_details_response_position."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_subaccounts_details_response_position."interest_value" is 'Value used to calculate realized_funding (perpetual only)';
comment on column deribit.private_get_subaccounts_details_response_position."kind" is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.private_get_subaccounts_details_response_position."leverage" is 'Current available leverage for future position';
comment on column deribit.private_get_subaccounts_details_response_position."maintenance_margin" is 'Maintenance margin';
comment on column deribit.private_get_subaccounts_details_response_position."mark_price" is 'Current mark price for position''s instrument';
comment on column deribit.private_get_subaccounts_details_response_position."realized_funding" is 'Realized Funding in current session included in session realized profit or loss, only for positions of perpetual instruments';
comment on column deribit.private_get_subaccounts_details_response_position."realized_profit_loss" is 'Realized profit or loss';
comment on column deribit.private_get_subaccounts_details_response_position."settlement_price" is 'Optional (not added for spot). Last settlement price for position''s instrument 0 if instrument wasn''t settled yet';
comment on column deribit.private_get_subaccounts_details_response_position."size" is 'Position size for futures size in quote currency (e.g. USD), for options size is in base currency (e.g. BTC)';
comment on column deribit.private_get_subaccounts_details_response_position."size_currency" is 'Only for futures, position size in base currency';
comment on column deribit.private_get_subaccounts_details_response_position."theta" is 'Only for options, Theta parameter';
comment on column deribit.private_get_subaccounts_details_response_position."total_profit_loss" is 'Profit or loss from position';
comment on column deribit.private_get_subaccounts_details_response_position."vega" is 'Only for options, Vega parameter';

create type deribit.private_get_subaccounts_details_response_open_order as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_get_subaccounts_details_response_open_order."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_get_subaccounts_details_response_open_order."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_get_subaccounts_details_response_open_order."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_get_subaccounts_details_response_open_order."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_get_subaccounts_details_response_open_order."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_subaccounts_details_response_open_order."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_get_subaccounts_details_response_open_order."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_get_subaccounts_details_response_open_order."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_get_subaccounts_details_response_open_order."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_get_subaccounts_details_response_open_order."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_subaccounts_details_response_open_order."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_get_subaccounts_details_response_open_order."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_get_subaccounts_details_response_open_order."api" is 'true if created with API';
comment on column deribit.private_get_subaccounts_details_response_open_order."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_get_subaccounts_details_response_open_order."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_get_subaccounts_details_response_open_order."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_get_subaccounts_details_response_open_order."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_get_subaccounts_details_response_open_order."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_get_subaccounts_details_response_open_order."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_get_subaccounts_details_response_open_order."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_get_subaccounts_details_response_open_order."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_subaccounts_details_response_open_order."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_subaccounts_details_response_open_order."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_get_subaccounts_details_response_open_order."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_get_subaccounts_details_response_open_order."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_get_subaccounts_details_response_open_order."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_subaccounts_details_response_open_order."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_subaccounts_details_response_open_order."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_subaccounts_details_response_open_order."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_get_subaccounts_details_response_open_order."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_get_subaccounts_details_response_open_order."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_get_subaccounts_details_response_open_order."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_subaccounts_details_response_open_order."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_subaccounts_details_response_open_order."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_get_subaccounts_details_response_open_order."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_subaccounts_details_response_open_order."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_get_subaccounts_details_response_open_order."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_get_subaccounts_details_response_open_order."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_get_subaccounts_details_response_open_order."order_id" is 'Unique order identifier';
comment on column deribit.private_get_subaccounts_details_response_open_order."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_get_subaccounts_details_response_open_order."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_get_subaccounts_details_response_open_order."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_get_subaccounts_details_response_open_order."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_get_subaccounts_details_response_open_order."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_get_subaccounts_details_response_open_order."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_subaccounts_details_response_open_order."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_subaccounts_details_response_open_order."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_get_subaccounts_details_response_open_order."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_subaccounts_details_response_open_order."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_get_subaccounts_details_response_open_order."average_price" is 'Average fill price of the order';
comment on column deribit.private_get_subaccounts_details_response_open_order."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_get_subaccounts_details_response_result as (
    "open_orders" deribit.private_get_subaccounts_details_response_open_order[],
    "positions" deribit.private_get_subaccounts_details_response_position[],
    "uid" bigint
);

comment on column deribit.private_get_subaccounts_details_response_result."uid" is 'Account/Subaccount identifier';

create type deribit.private_get_subaccounts_details_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_subaccounts_details_response_result[]
);

comment on column deribit.private_get_subaccounts_details_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_subaccounts_details_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_subaccounts_details(
    "currency" deribit.private_get_subaccounts_details_request_currency,
    "with_open_orders" boolean default null
)
returns setof deribit.private_get_subaccounts_details_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "with_open_orders"
        )::deribit.private_get_subaccounts_details_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_subaccounts_details'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_subaccounts_details_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."open_orders"::deribit.private_get_subaccounts_details_response_open_order[],
        (b)."positions"::deribit.private_get_subaccounts_details_response_position[],
        (b)."uid"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_subaccounts_details is 'Get subaccounts positions';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_transaction_log_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_transaction_log_request as (
    "currency" deribit.private_get_transaction_log_request_currency,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "query" text,
    "count" bigint,
    "continuation" bigint
);

comment on column deribit.private_get_transaction_log_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_transaction_log_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_transaction_log_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_transaction_log_request."query" is 'The following keywords can be used to filter the results: trade, maker, taker, open, close, liquidation, buy, sell, withdrawal, delivery, settlement, deposit, transfer, option, future, correction, block_trade, swap. Plus withdrawal or transfer addresses';
comment on column deribit.private_get_transaction_log_request."count" is 'Number of requested items, default - 100';
comment on column deribit.private_get_transaction_log_request."continuation" is 'Continuation token for pagination';

create type deribit.private_get_transaction_log_response_log as (
    "amount" double precision,
    "balance" double precision,
    "cashflow" double precision,
    "change" double precision,
    "commission" double precision,
    "contracts" double precision,
    "currency" text,
    "equity" double precision,
    "id" bigint,
    "info" jsonb,
    "instrument_name" text,
    "interest_pl" double precision,
    "mark_price" double precision,
    "order_id" text,
    "position" double precision,
    "price" double precision,
    "price_currency" text,
    "profit_as_cashflow" boolean,
    "session_rpl" double precision,
    "session_upl" double precision,
    "side" text,
    "timestamp" bigint,
    "total_interest_pl" double precision,
    "trade_id" text,
    "type" text,
    "user_id" bigint,
    "user_role" text,
    "user_seq" bigint,
    "username" text
);

comment on column deribit.private_get_transaction_log_response_log."amount" is 'It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is the underlying base currency coin. For options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_get_transaction_log_response_log."balance" is 'Cash balance after the transaction';
comment on column deribit.private_get_transaction_log_response_log."cashflow" is 'For futures and perpetual contracts: Realized session PNL (since last settlement). For options: the amount paid or received for the options traded.';
comment on column deribit.private_get_transaction_log_response_log."change" is 'Change in cash balance. For trades: fees and options premium paid/received. For settlement: Futures session PNL and perpetual session funding.';
comment on column deribit.private_get_transaction_log_response_log."commission" is 'Commission paid so far (in base currency)';
comment on column deribit.private_get_transaction_log_response_log."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_get_transaction_log_response_log."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_transaction_log_response_log."equity" is 'Updated equity value after the transaction';
comment on column deribit.private_get_transaction_log_response_log."id" is 'Unique identifier';
comment on column deribit.private_get_transaction_log_response_log."info" is 'Additional information regarding transaction. Strongly dependent on the log entry type';
comment on column deribit.private_get_transaction_log_response_log."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_transaction_log_response_log."interest_pl" is 'Actual funding rate of trades and settlements on perpetual instruments';
comment on column deribit.private_get_transaction_log_response_log."mark_price" is 'Market price during the trade';
comment on column deribit.private_get_transaction_log_response_log."order_id" is 'Unique order identifier';
comment on column deribit.private_get_transaction_log_response_log."position" is 'Updated position size after the transaction';
comment on column deribit.private_get_transaction_log_response_log."price" is 'Settlement/delivery price or the price level of the traded contracts';
comment on column deribit.private_get_transaction_log_response_log."price_currency" is 'Currency symbol associated with the price field value';
comment on column deribit.private_get_transaction_log_response_log."profit_as_cashflow" is 'Indicator informing whether the cashflow is waiting for settlement or not';
comment on column deribit.private_get_transaction_log_response_log."session_rpl" is 'Session realized profit and loss';
comment on column deribit.private_get_transaction_log_response_log."session_upl" is 'Session unrealized profit and loss';
comment on column deribit.private_get_transaction_log_response_log."side" is 'One of: short or long in case of settlements, close sell or close buy in case of deliveries, open sell, open buy, close sell, close buy in case of trades';
comment on column deribit.private_get_transaction_log_response_log."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_transaction_log_response_log."total_interest_pl" is 'Total session funding rate';
comment on column deribit.private_get_transaction_log_response_log."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_transaction_log_response_log."type" is 'Transaction category/type. The most common are: trade, deposit, withdrawal, settlement, delivery, transfer, swap, correction. New types can be added any time in the future';
comment on column deribit.private_get_transaction_log_response_log."user_id" is 'Unique user identifier';
comment on column deribit.private_get_transaction_log_response_log."user_role" is 'Trade role of the user: maker or taker';
comment on column deribit.private_get_transaction_log_response_log."user_seq" is 'Sequential identifier of user transaction';
comment on column deribit.private_get_transaction_log_response_log."username" is 'System name or user defined subaccount alias';

create type deribit.private_get_transaction_log_response_result as (
    "continuation" bigint,
    "logs" deribit.private_get_transaction_log_response_log[]
);

comment on column deribit.private_get_transaction_log_response_result."continuation" is 'Continuation token for pagination. NULL when no continuation.';

create type deribit.private_get_transaction_log_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_transaction_log_response_result
);

comment on column deribit.private_get_transaction_log_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_transaction_log_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_transaction_log(
    "currency" deribit.private_get_transaction_log_request_currency,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "query" text default null,
    "count" bigint default null,
    "continuation" bigint default null
)
returns deribit.private_get_transaction_log_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "start_timestamp",
            "end_timestamp",
            "query",
            "count",
            "continuation"
        )::deribit.private_get_transaction_log_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_transaction_log'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_transaction_log_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_transaction_log is 'Retrieve the latest user trades that have occurred for a specific instrument and within a given time range.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_transfers_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_transfers_request as (
    "currency" deribit.private_get_transfers_request_currency,
    "count" bigint,
    "offset" bigint
);

comment on column deribit.private_get_transfers_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_transfers_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_transfers_request."offset" is 'The offset for pagination, default - 0';

create type deribit.private_get_transfers_response_datum as (
    "amount" double precision,
    "created_timestamp" bigint,
    "currency" text,
    "direction" text,
    "id" bigint,
    "other_side" text,
    "state" text,
    "type" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_get_transfers_response_datum."amount" is 'Amount of funds in given currency';
comment on column deribit.private_get_transfers_response_datum."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_transfers_response_datum."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_transfers_response_datum."direction" is 'Transfer direction';
comment on column deribit.private_get_transfers_response_datum."id" is 'Id of transfer';
comment on column deribit.private_get_transfers_response_datum."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_get_transfers_response_datum."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_get_transfers_response_datum."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_get_transfers_response_datum."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_transfers_response_result as (
    "count" bigint,
    "data" deribit.private_get_transfers_response_datum[]
);

comment on column deribit.private_get_transfers_response_result."count" is 'Total number of results available';

create type deribit.private_get_transfers_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_transfers_response_result
);

comment on column deribit.private_get_transfers_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_transfers_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_transfers(
    "currency" deribit.private_get_transfers_request_currency,
    "count" bigint default null,
    "offset" bigint default null
)
returns deribit.private_get_transfers_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "count",
            "offset"
        )::deribit.private_get_transfers_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_transfers'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_transfers_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_transfers is 'Retrieve the user''s transfers list';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_trigger_order_history_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_trigger_order_history_request as (
    "currency" deribit.private_get_trigger_order_history_request_currency,
    "instrument_name" text,
    "count" bigint,
    "continuation" text
);

comment on column deribit.private_get_trigger_order_history_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_trigger_order_history_request."instrument_name" is 'Instrument name';
comment on column deribit.private_get_trigger_order_history_request."count" is 'Number of requested items, default - 20';
comment on column deribit.private_get_trigger_order_history_request."continuation" is 'Continuation token for pagination';

create type deribit.private_get_trigger_order_history_response_entry as (
    "amount" double precision,
    "direction" text,
    "instrument_name" text,
    "is_secondary_oto" boolean,
    "label" text,
    "last_update_timestamp" bigint,
    "oco_ref" text,
    "order_id" text,
    "order_state" text,
    "order_type" text,
    "post_only" boolean,
    "price" double precision,
    "reduce_only" boolean,
    "request" text,
    "source" text,
    "timestamp" bigint,
    "trigger" text,
    "trigger_offset" double precision,
    "trigger_order_id" text,
    "trigger_price" double precision
);

comment on column deribit.private_get_trigger_order_history_response_entry."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_trigger_order_history_response_entry."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_trigger_order_history_response_entry."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_trigger_order_history_response_entry."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_get_trigger_order_history_response_entry."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_trigger_order_history_response_entry."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_trigger_order_history_response_entry."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_get_trigger_order_history_response_entry."order_id" is 'Unique order identifier';
comment on column deribit.private_get_trigger_order_history_response_entry."order_state" is 'Order state: "triggered", "cancelled", or "rejected" with rejection reason (e.g. "rejected:reduce_direction").';
comment on column deribit.private_get_trigger_order_history_response_entry."order_type" is 'Requested order type: "limit or "market"';
comment on column deribit.private_get_trigger_order_history_response_entry."post_only" is 'true for post-only orders only';
comment on column deribit.private_get_trigger_order_history_response_entry."price" is 'Price in base currency';
comment on column deribit.private_get_trigger_order_history_response_entry."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_get_trigger_order_history_response_entry."request" is 'Type of last request performed on the trigger order by user or system. "cancel" - when order was cancelled, "trigger:order" - when trigger order spawned market or limit order after being triggered';
comment on column deribit.private_get_trigger_order_history_response_entry."source" is 'Source of the order that is linked to the trigger order.';
comment on column deribit.private_get_trigger_order_history_response_entry."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger_order_id" is 'Id of the user order used for the trigger-order reference before triggering';
comment on column deribit.private_get_trigger_order_history_response_entry."trigger_price" is 'Trigger price (Only for future trigger orders)';

create type deribit.private_get_trigger_order_history_response_result as (
    "continuation" text,
    "entries" deribit.private_get_trigger_order_history_response_entry[]
);

comment on column deribit.private_get_trigger_order_history_response_result."continuation" is 'Continuation token for pagination.';

create type deribit.private_get_trigger_order_history_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_trigger_order_history_response_result
);

comment on column deribit.private_get_trigger_order_history_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_trigger_order_history_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_trigger_order_history(
    "currency" deribit.private_get_trigger_order_history_request_currency,
    "instrument_name" text default null,
    "count" bigint default null,
    "continuation" text default null
)
returns deribit.private_get_trigger_order_history_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "instrument_name",
            "count",
            "continuation"
        )::deribit.private_get_trigger_order_history_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_trigger_order_history'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_trigger_order_history_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_trigger_order_history is 'Retrieves detailed log of the user''s trigger orders.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_user_locks_response_result as (
    "currency" text,
    "enabled" boolean,
    "message" text
);

comment on column deribit.private_get_user_locks_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_locks_response_result."enabled" is 'Value is set to ''true'' when user account is locked in currency';
comment on column deribit.private_get_user_locks_response_result."message" is 'Optional information for user why his account is locked';

create type deribit.private_get_user_locks_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_user_locks_response_result[]
);

comment on column deribit.private_get_user_locks_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_user_locks_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_user_locks()
returns setof deribit.private_get_user_locks_response_result
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_user_locks'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_user_locks_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."currency"::text,
        (b)."enabled"::boolean,
        (b)."message"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_user_locks is 'Retrieves information about locks on user account';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_user_trades_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_user_trades_by_currency_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_get_user_trades_by_currency_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.private_get_user_trades_by_currency_request as (
    "currency" deribit.private_get_user_trades_by_currency_request_currency,
    "kind" deribit.private_get_user_trades_by_currency_request_kind,
    "start_id" text,
    "end_id" text,
    "count" bigint,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "sorting" deribit.private_get_user_trades_by_currency_request_sorting,
    "subaccount_id" bigint
);

comment on column deribit.private_get_user_trades_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_user_trades_by_currency_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_get_user_trades_by_currency_request."start_id" is 'The ID of the first trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.private_get_user_trades_by_currency_request."end_id" is 'The ID of the last trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.private_get_user_trades_by_currency_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_user_trades_by_currency_request."start_timestamp" is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.private_get_user_trades_by_currency_request."end_timestamp" is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.private_get_user_trades_by_currency_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';
comment on column deribit.private_get_user_trades_by_currency_request."subaccount_id" is 'The user id for the subaccount';

create type deribit.private_get_user_trades_by_currency_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_user_trades_by_currency_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_currency_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_currency_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_currency_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_currency_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_currency_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_currency_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_currency_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_currency_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_currency_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_currency_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_currency_response_trade."matching_id" is 'Always null';
comment on column deribit.private_get_user_trades_by_currency_response_trade."price" is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_currency_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_currency_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_currency_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_currency_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_currency_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_currency_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_currency_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_currency_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_user_trades_by_currency_response_result as (
    "has_more" boolean,
    "trades" deribit.private_get_user_trades_by_currency_response_trade[]
);

create type deribit.private_get_user_trades_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_user_trades_by_currency_response_result
);

comment on column deribit.private_get_user_trades_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_user_trades_by_currency(
    "currency" deribit.private_get_user_trades_by_currency_request_currency,
    "kind" deribit.private_get_user_trades_by_currency_request_kind default null,
    "start_id" text default null,
    "end_id" text default null,
    "count" bigint default null,
    "start_timestamp" bigint default null,
    "end_timestamp" bigint default null,
    "sorting" deribit.private_get_user_trades_by_currency_request_sorting default null,
    "subaccount_id" bigint default null
)
returns deribit.private_get_user_trades_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "start_id",
            "end_id",
            "count",
            "start_timestamp",
            "end_timestamp",
            "sorting",
            "subaccount_id"
        )::deribit.private_get_user_trades_by_currency_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_user_trades_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_user_trades_by_currency_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_user_trades_by_currency is 'Retrieve the latest user trades that have occurred for instruments in a specific currency symbol. To read subaccount trades, use subaccount_id parameter.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_user_trades_by_currency_and_time_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_user_trades_by_currency_and_time_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.private_get_user_trades_by_currency_and_time_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.private_get_user_trades_by_currency_and_time_request as (
    "currency" deribit.private_get_user_trades_by_currency_and_time_request_currency,
    "kind" deribit.private_get_user_trades_by_currency_and_time_request_kind,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint,
    "sorting" deribit.private_get_user_trades_by_currency_and_time_request_sorting
);

comment on column deribit.private_get_user_trades_by_currency_and_time_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_user_trades_by_currency_and_time_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.private_get_user_trades_by_currency_and_time_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.private_get_user_trades_by_currency_and_time_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.private_get_user_trades_by_currency_and_time_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_user_trades_by_currency_and_time_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.private_get_user_trades_by_currency_and_time_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."matching_id" is 'Always null';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."price" is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_currency_and_time_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_user_trades_by_currency_and_time_response_result as (
    "has_more" boolean,
    "trades" deribit.private_get_user_trades_by_currency_and_time_response_trade[]
);

create type deribit.private_get_user_trades_by_currency_and_time_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_user_trades_by_currency_and_time_response_result
);

comment on column deribit.private_get_user_trades_by_currency_and_time_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_currency_and_time_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_user_trades_by_currency_and_time(
    "currency" deribit.private_get_user_trades_by_currency_and_time_request_currency,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "kind" deribit.private_get_user_trades_by_currency_and_time_request_kind default null,
    "count" bigint default null,
    "sorting" deribit.private_get_user_trades_by_currency_and_time_request_sorting default null
)
returns deribit.private_get_user_trades_by_currency_and_time_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "start_timestamp",
            "end_timestamp",
            "count",
            "sorting"
        )::deribit.private_get_user_trades_by_currency_and_time_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_user_trades_by_currency_and_time'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_user_trades_by_currency_and_time_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_user_trades_by_currency_and_time is 'Retrieve the latest user trades that have occurred for instruments in a specific currency symbol and within a given time range.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_user_trades_by_instrument_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.private_get_user_trades_by_instrument_request as (
    "instrument_name" text,
    "start_seq" bigint,
    "end_seq" bigint,
    "count" bigint,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "sorting" deribit.private_get_user_trades_by_instrument_request_sorting
);

comment on column deribit.private_get_user_trades_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_user_trades_by_instrument_request."start_seq" is 'The sequence number of the first trade to be returned';
comment on column deribit.private_get_user_trades_by_instrument_request."end_seq" is 'The sequence number of the last trade to be returned';
comment on column deribit.private_get_user_trades_by_instrument_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_user_trades_by_instrument_request."start_timestamp" is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.private_get_user_trades_by_instrument_request."end_timestamp" is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.private_get_user_trades_by_instrument_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.private_get_user_trades_by_instrument_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_user_trades_by_instrument_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."matching_id" is 'Always null';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."price" is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_instrument_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_user_trades_by_instrument_response_result as (
    "has_more" boolean,
    "trades" deribit.private_get_user_trades_by_instrument_response_trade[]
);

create type deribit.private_get_user_trades_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_user_trades_by_instrument_response_result
);

comment on column deribit.private_get_user_trades_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_user_trades_by_instrument(
    "instrument_name" text,
    "start_seq" bigint default null,
    "end_seq" bigint default null,
    "count" bigint default null,
    "start_timestamp" bigint default null,
    "end_timestamp" bigint default null,
    "sorting" deribit.private_get_user_trades_by_instrument_request_sorting default null
)
returns deribit.private_get_user_trades_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_seq",
            "end_seq",
            "count",
            "start_timestamp",
            "end_timestamp",
            "sorting"
        )::deribit.private_get_user_trades_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_user_trades_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_user_trades_by_instrument_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_user_trades_by_instrument is 'Retrieve the latest user trades that have occurred for a specific instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_user_trades_by_instrument_and_time_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.private_get_user_trades_by_instrument_and_time_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint,
    "sorting" deribit.private_get_user_trades_by_instrument_and_time_request_sorting
);

comment on column deribit.private_get_user_trades_by_instrument_and_time_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_get_user_trades_by_instrument_and_time_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.private_get_user_trades_by_instrument_and_time_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.private_get_user_trades_by_instrument_and_time_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_user_trades_by_instrument_and_time_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.private_get_user_trades_by_instrument_and_time_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."matching_id" is 'Always null';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."price" is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_user_trades_by_instrument_and_time_response_result as (
    "has_more" boolean,
    "trades" deribit.private_get_user_trades_by_instrument_and_time_response_trade[]
);

create type deribit.private_get_user_trades_by_instrument_and_time_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_user_trades_by_instrument_and_time_response_result
);

comment on column deribit.private_get_user_trades_by_instrument_and_time_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_instrument_and_time_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_user_trades_by_instrument_and_time(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint default null,
    "sorting" deribit.private_get_user_trades_by_instrument_and_time_request_sorting default null
)
returns deribit.private_get_user_trades_by_instrument_and_time_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp",
            "count",
            "sorting"
        )::deribit.private_get_user_trades_by_instrument_and_time_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_user_trades_by_instrument_and_time'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_user_trades_by_instrument_and_time_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_user_trades_by_instrument_and_time is 'Retrieve the latest user trades that have occurred for a specific instrument and within a given time range.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_user_trades_by_order_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.private_get_user_trades_by_order_request as (
    "order_id" text,
    "sorting" deribit.private_get_user_trades_by_order_request_sorting
);

comment on column deribit.private_get_user_trades_by_order_request."order_id" is '(Required) The order id';
comment on column deribit.private_get_user_trades_by_order_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.private_get_user_trades_by_order_response_result as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_get_user_trades_by_order_response_result."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_get_user_trades_by_order_response_result."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_get_user_trades_by_order_response_result."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_order_response_result."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_get_user_trades_by_order_response_result."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_order_response_result."api" is 'true if user order was created with API';
comment on column deribit.private_get_user_trades_by_order_response_result."mmp" is 'true if user order is MMP';
comment on column deribit.private_get_user_trades_by_order_response_result."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_get_user_trades_by_order_response_result."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_get_user_trades_by_order_response_result."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_get_user_trades_by_order_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_get_user_trades_by_order_response_result."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_trades_by_order_response_result."direction" is 'Direction: buy, or sell';
comment on column deribit.private_get_user_trades_by_order_response_result."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_get_user_trades_by_order_response_result."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_get_user_trades_by_order_response_result."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_get_user_trades_by_order_response_result."matching_id" is 'Always null';
comment on column deribit.private_get_user_trades_by_order_response_result."price" is 'Price in base currency';
comment on column deribit.private_get_user_trades_by_order_response_result."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_get_user_trades_by_order_response_result."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_get_user_trades_by_order_response_result."post_only" is 'true if user order is post-only';
comment on column deribit.private_get_user_trades_by_order_response_result."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_get_user_trades_by_order_response_result."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_order_response_result."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_get_user_trades_by_order_response_result."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_get_user_trades_by_order_response_result."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_get_user_trades_by_order_response_result."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_get_user_trades_by_order_response_result."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_get_user_trades_by_order_response_result."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_get_user_trades_by_order_response_result."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_get_user_trades_by_order_response_result."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_get_user_trades_by_order_response_result."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_get_user_trades_by_order_response_result."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_get_user_trades_by_order_response_result."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_get_user_trades_by_order_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_user_trades_by_order_response_result[]
);

comment on column deribit.private_get_user_trades_by_order_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_user_trades_by_order_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_user_trades_by_order(
    "order_id" text,
    "sorting" deribit.private_get_user_trades_by_order_request_sorting default null
)
returns setof deribit.private_get_user_trades_by_order_response_result
language sql
as $$
    
    with request as (
        select row(
            "order_id",
            "sorting"
        )::deribit.private_get_user_trades_by_order_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_user_trades_by_order'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_get_user_trades_by_order_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."timestamp"::bigint,
        (b)."label"::text,
        (b)."fee"::double precision,
        (b)."quote_id"::text,
        (b)."liquidity"::text,
        (b)."index_price"::double precision,
        (b)."api"::boolean,
        (b)."mmp"::boolean,
        (b)."legs"::text[],
        (b)."trade_seq"::bigint,
        (b)."risk_reducing"::boolean,
        (b)."instrument_name"::text,
        (b)."fee_currency"::text,
        (b)."direction"::text,
        (b)."trade_id"::text,
        (b)."tick_direction"::bigint,
        (b)."profit_loss"::double precision,
        (b)."matching_id"::text,
        (b)."price"::double precision,
        (b)."reduce_only"::text,
        (b)."amount"::double precision,
        (b)."post_only"::text,
        (b)."liquidation"::text,
        (b)."combo_trade_id"::double precision,
        (b)."order_id"::text,
        (b)."block_trade_id"::text,
        (b)."order_type"::text,
        (b)."quote_set_id"::text,
        (b)."combo_id"::text,
        (b)."underlying_price"::double precision,
        (b)."contracts"::double precision,
        (b)."mark_price"::double precision,
        (b)."iv"::double precision,
        (b)."state"::text,
        (b)."advanced"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_user_trades_by_order is 'Retrieve the list of user trades that was created for given order';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_get_withdrawals_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_get_withdrawals_request as (
    "currency" deribit.private_get_withdrawals_request_currency,
    "count" bigint,
    "offset" bigint
);

comment on column deribit.private_get_withdrawals_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_get_withdrawals_request."count" is 'Number of requested items, default - 10';
comment on column deribit.private_get_withdrawals_request."offset" is 'The offset for pagination, default - 0';

create type deribit.private_get_withdrawals_response_datum as (
    "address" text,
    "amount" double precision,
    "confirmed_timestamp" bigint,
    "created_timestamp" bigint,
    "currency" text,
    "fee" double precision,
    "id" bigint,
    "priority" double precision,
    "state" text,
    "transaction_id" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_get_withdrawals_response_datum."address" is 'Address in proper format for currency';
comment on column deribit.private_get_withdrawals_response_datum."amount" is 'Amount of funds in given currency';
comment on column deribit.private_get_withdrawals_response_datum."confirmed_timestamp" is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_get_withdrawals_response_datum."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_get_withdrawals_response_datum."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_withdrawals_response_datum."fee" is 'Fee in currency';
comment on column deribit.private_get_withdrawals_response_datum."id" is 'Withdrawal id in Deribit system';
comment on column deribit.private_get_withdrawals_response_datum."priority" is 'Id of priority level';
comment on column deribit.private_get_withdrawals_response_datum."state" is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_get_withdrawals_response_datum."transaction_id" is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_get_withdrawals_response_datum."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_get_withdrawals_response_result as (
    "count" bigint,
    "data" deribit.private_get_withdrawals_response_datum[]
);

comment on column deribit.private_get_withdrawals_response_result."count" is 'Total number of results available';

create type deribit.private_get_withdrawals_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_get_withdrawals_response_result
);

comment on column deribit.private_get_withdrawals_response."id" is 'The id that was sent in the request';
comment on column deribit.private_get_withdrawals_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_get_withdrawals(
    "currency" deribit.private_get_withdrawals_request_currency,
    "count" bigint default null,
    "offset" bigint default null
)
returns deribit.private_get_withdrawals_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "count",
            "offset"
        )::deribit.private_get_withdrawals_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/get_withdrawals'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_get_withdrawals_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_get_withdrawals is 'Retrieve the latest users withdrawals';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_invalidate_block_trade_signature_request as (
    "signature" text
);

comment on column deribit.private_invalidate_block_trade_signature_request."signature" is '(Required) Signature of block trade that will be invalidated';

create type deribit.private_invalidate_block_trade_signature_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_invalidate_block_trade_signature_response."id" is 'The id that was sent in the request';
comment on column deribit.private_invalidate_block_trade_signature_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_invalidate_block_trade_signature_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_invalidate_block_trade_signature(
    "signature" text
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "signature"
        )::deribit.private_invalidate_block_trade_signature_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/invalidate_block_trade_signature'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_invalidate_block_trade_signature_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_invalidate_block_trade_signature is 'User at any time (before the private/execute_block_trade is called) can invalidate its own signature effectively cancelling block trade';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_list_api_keys_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_list_api_keys_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_list_api_keys_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_list_api_keys_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_list_api_keys_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_list_api_keys_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_list_api_keys_response_result."id" is 'key identifier';
comment on column deribit.private_list_api_keys_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_list_api_keys_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_list_api_keys_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_list_api_keys_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_list_api_keys_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_list_api_keys_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_list_api_keys_response_result[]
);

comment on column deribit.private_list_api_keys_response."id" is 'The id that was sent in the request';
comment on column deribit.private_list_api_keys_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_list_api_keys()
returns setof deribit.private_list_api_keys_response_result
language sql
as $$
    with http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/list_api_keys'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_list_api_keys_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."client_id"::text,
        (b)."client_secret"::text,
        (b)."default"::boolean,
        (b)."enabled"::boolean,
        (b)."enabled_features"::text[],
        (b)."id"::bigint,
        (b)."ip_whitelist"::text[],
        (b)."max_scope"::text,
        (b)."name"::text,
        (b)."public_key"::text,
        (b)."timestamp"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_list_api_keys is 'Retrieves list of api keys. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_list_custody_accounts_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_list_custody_accounts_request as (
    "currency" deribit.private_list_custody_accounts_request_currency
);

comment on column deribit.private_list_custody_accounts_request."currency" is '(Required) The currency symbol';

create type deribit.private_list_custody_accounts_response_result as (
    "auto_deposit" boolean,
    "balance" double precision,
    "client_id" text,
    "currency" text,
    "deposit_address" text,
    "external_id" text,
    "name" text,
    "pending_withdrawal_addres" text,
    "pending_withdrawal_balance" double precision,
    "withdrawal_address" text,
    "withdrawal_address_change" double precision
);

comment on column deribit.private_list_custody_accounts_response_result."auto_deposit" is 'When set to ''true'' all new funds added to custody balance will be automatically transferred to trading balance';
comment on column deribit.private_list_custody_accounts_response_result."balance" is 'Amount of funds in given currency';
comment on column deribit.private_list_custody_accounts_response_result."client_id" is 'API key ''client id'' used to reserve/release funds in custody platform, requires scope ''custody:read_write''';
comment on column deribit.private_list_custody_accounts_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_list_custody_accounts_response_result."deposit_address" is 'Address that can be used for deposits';
comment on column deribit.private_list_custody_accounts_response_result."external_id" is 'User ID in external systems';
comment on column deribit.private_list_custody_accounts_response_result."name" is 'Custody name';
comment on column deribit.private_list_custody_accounts_response_result."pending_withdrawal_addres" is 'New withdrawal address that will be used after ''withdrawal_address_change''';
comment on column deribit.private_list_custody_accounts_response_result."pending_withdrawal_balance" is 'Amount of funds in given currency';
comment on column deribit.private_list_custody_accounts_response_result."withdrawal_address" is 'Address that is used for withdrawals';
comment on column deribit.private_list_custody_accounts_response_result."withdrawal_address_change" is 'UNIX timestamp after when new withdrawal address will be used for withdrawals';

create type deribit.private_list_custody_accounts_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_list_custody_accounts_response_result[]
);

comment on column deribit.private_list_custody_accounts_response."id" is 'The id that was sent in the request';
comment on column deribit.private_list_custody_accounts_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_list_custody_accounts_response."result" is 'Custody account';

create function deribit.private_list_custody_accounts(
    "currency" deribit.private_list_custody_accounts_request_currency
)
returns setof deribit.private_list_custody_accounts_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.private_list_custody_accounts_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/list_custody_accounts'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_list_custody_accounts_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."auto_deposit"::boolean,
        (b)."balance"::double precision,
        (b)."client_id"::text,
        (b)."currency"::text,
        (b)."deposit_address"::text,
        (b)."external_id"::text,
        (b)."name"::text,
        (b)."pending_withdrawal_addres"::text,
        (b)."pending_withdrawal_balance"::double precision,
        (b)."withdrawal_address"::text,
        (b)."withdrawal_address_change"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_list_custody_accounts is 'Retrieves user custody accounts list.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_logout_request as (
    "invalidate_token" boolean
);

comment on column deribit.private_logout_request."invalidate_token" is 'If value is true all tokens created in current session are invalidated, default: true';

create type deribit.private_logout_response as (
    "id" bigint,
    "jsonrpc" text
);

create function deribit.private_logout(
    "invalidate_token" boolean default null
)
returns void
language sql
as $$
    
    with request as (
        select row(
            "invalidate_token"
        )::deribit.private_logout_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/logout'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
            select null::void as result
        
$$;

comment on function deribit.private_logout is 'Gracefully close websocket connection, when COD (Cancel On Disconnect) is enabled orders are not cancelled';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_move_positions_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_move_positions_request_trade as (
    "instrument_name" text,
    "price" double precision,
    "amount" double precision
);

comment on column deribit.private_move_positions_request_trade."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_move_positions_request_trade."price" is 'Price for trade - if not provided average price of the position is used';
comment on column deribit.private_move_positions_request_trade."amount" is '(Required) It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH. Amount can''t exceed position size.';

create type deribit.private_move_positions_request as (
    "currency" deribit.private_move_positions_request_currency,
    "source_uid" bigint,
    "target_uid" bigint,
    "trades" deribit.private_move_positions_request_trade[]
);

comment on column deribit.private_move_positions_request."currency" is 'The currency symbol';
comment on column deribit.private_move_positions_request."source_uid" is '(Required) Id of source subaccount. Can be found in My Account >> Subaccounts tab';
comment on column deribit.private_move_positions_request."target_uid" is '(Required) Id of target subaccount. Can be found in My Account >> Subaccounts tab';
comment on column deribit.private_move_positions_request."trades" is '(Required) List of trades for position move';

create type deribit.private_move_positions_response_trade as (
    "amount" double precision,
    "direction" text,
    "instrument_name" text,
    "price" double precision,
    "source_uid" bigint,
    "target_uid" bigint
);

comment on column deribit.private_move_positions_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_move_positions_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_move_positions_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_move_positions_response_trade."price" is 'Price in base currency';
comment on column deribit.private_move_positions_response_trade."source_uid" is 'Trade source uid';
comment on column deribit.private_move_positions_response_trade."target_uid" is 'Trade target uid';

create type deribit.private_move_positions_response_result as (
    "trades" deribit.private_move_positions_response_trade[]
);

create type deribit.private_move_positions_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_move_positions_response_result
);

comment on column deribit.private_move_positions_response."id" is 'The id that was sent in the request';
comment on column deribit.private_move_positions_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_move_positions(
    "source_uid" bigint,
    "target_uid" bigint,
    "trades" deribit.private_move_positions_request_trade[],
    "currency" deribit.private_move_positions_request_currency default null
)
returns deribit.private_move_positions_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "source_uid",
            "target_uid",
            "trades"
        )::deribit.private_move_positions_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/move_positions'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_move_positions_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_move_positions is 'Moves positions from source subaccount to target subaccount';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_pme_simulate_request_currency as enum (
    'BTC',
    'CROSS',
    'ETH',
    'EURR',
    'MATIC',
    'SOL',
    'USDC',
    'USDT',
    'XRP'
);

create type deribit.private_pme_simulate_request as (
    "currency" deribit.private_pme_simulate_request_currency
);

comment on column deribit.private_pme_simulate_request."currency" is '(Required) The currency for which the Extended Risk Matrix will be calculated. Use CROSS for Cross Collateral simulation.';

create type deribit.private_pme_simulate_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" jsonb
);

comment on column deribit.private_pme_simulate_response."id" is 'The id that was sent in the request';
comment on column deribit.private_pme_simulate_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_pme_simulate_response."result" is 'PM details';

create function deribit.private_pme_simulate(
    "currency" deribit.private_pme_simulate_request_currency
)
returns jsonb
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.private_pme_simulate_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/pme/simulate'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_pme_simulate_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_pme_simulate is 'Calculates the Extended Risk Matrix and margin information for the selected currency or against the entire Cross-Collateral portfolio.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_reject_block_trade_request_role as enum (
    'maker',
    'taker'
);

create type deribit.private_reject_block_trade_request as (
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_reject_block_trade_request_role
);

comment on column deribit.private_reject_block_trade_request."timestamp" is '(Required) Timestamp, shared with other party (milliseconds since the UNIX epoch)';
comment on column deribit.private_reject_block_trade_request."nonce" is '(Required) Nonce, shared with other party';
comment on column deribit.private_reject_block_trade_request."role" is '(Required) Describes if user wants to be maker or taker of trades';

create type deribit.private_reject_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_reject_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_reject_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_reject_block_trade_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_reject_block_trade(
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_reject_block_trade_request_role
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "timestamp",
            "nonce",
            "role"
        )::deribit.private_reject_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/reject_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_reject_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_reject_block_trade is 'Used to reject a pending block trade. nonce and timestamp are used to identify the block trade while role should be opposite to the trading counterparty. To use a block trade approval feature the additional API key setting feature called: enabled_features: block_trade_approval is required. This key has to be given to broker/registered partner who performs the trades on behalf of the user for the feature to be active. If the user wants to approve the trade, he has to approve it from different API key with doesn''t have this feature enabled.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_remove_api_key_request as (
    "id" bigint
);

comment on column deribit.private_remove_api_key_request."id" is '(Required) Id of key';

create type deribit.private_remove_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_remove_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_remove_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_remove_api_key_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_remove_api_key(
    "id" bigint
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "id"
        )::deribit.private_remove_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/remove_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_remove_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_remove_api_key is 'Removes api key. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_remove_subaccount_request as (
    "subaccount_id" bigint
);

comment on column deribit.private_remove_subaccount_request."subaccount_id" is '(Required) The user id for the subaccount';

create type deribit.private_remove_subaccount_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_remove_subaccount_response."id" is 'The id that was sent in the request';
comment on column deribit.private_remove_subaccount_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_remove_subaccount_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_remove_subaccount(
    "subaccount_id" bigint
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "subaccount_id"
        )::deribit.private_remove_subaccount_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/remove_subaccount'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_remove_subaccount_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_remove_subaccount is 'Remove empty subaccount.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_reset_api_key_request as (
    "id" bigint
);

comment on column deribit.private_reset_api_key_request."id" is '(Required) Id of key';

create type deribit.private_reset_api_key_response_result as (
    "client_id" text,
    "client_secret" text,
    "default" boolean,
    "enabled" boolean,
    "enabled_features" text[],
    "id" bigint,
    "ip_whitelist" text[],
    "max_scope" text,
    "name" text,
    "public_key" text,
    "timestamp" bigint
);

comment on column deribit.private_reset_api_key_response_result."client_id" is 'Client identifier used for authentication';
comment on column deribit.private_reset_api_key_response_result."client_secret" is 'Client secret or MD5 fingerprint of public key used for authentication';
comment on column deribit.private_reset_api_key_response_result."default" is 'Informs whether this api key is default (field is deprecated and will be removed in the future)';
comment on column deribit.private_reset_api_key_response_result."enabled" is 'Informs whether api key is enabled and can be used for authentication';
comment on column deribit.private_reset_api_key_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.private_reset_api_key_response_result."id" is 'key identifier';
comment on column deribit.private_reset_api_key_response_result."ip_whitelist" is 'List of IP addresses whitelisted for a selected key';
comment on column deribit.private_reset_api_key_response_result."max_scope" is 'Describes maximal access for tokens generated with given key, possible values: trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], block_trade:[read, read_write, none]. If scope is not provided, its value is set as none. Please check details described in Access scope';
comment on column deribit.private_reset_api_key_response_result."name" is 'Api key name that can be displayed in transaction log';
comment on column deribit.private_reset_api_key_response_result."public_key" is 'PEM encoded public key (Ed25519/RSA) used for asymmetric signatures (optional)';
comment on column deribit.private_reset_api_key_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_reset_api_key_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_reset_api_key_response_result
);

comment on column deribit.private_reset_api_key_response."id" is 'The id that was sent in the request';
comment on column deribit.private_reset_api_key_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_reset_api_key(
    "id" bigint
)
returns deribit.private_reset_api_key_response_result
language sql
as $$
    
    with request as (
        select row(
            "id"
        )::deribit.private_reset_api_key_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/reset_api_key'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_reset_api_key_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_reset_api_key is 'Resets secret in api key. Important notes.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_reset_mmp_request_index_name as enum (
    'ada_usdc',
    'ada_usdt',
    'algo_usdc',
    'algo_usdt',
    'avax_usdc',
    'avax_usdt',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usdc',
    'doge_usdt',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usdc',
    'link_usdt',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usdc',
    'matic_usdt',
    'near_usdc',
    'near_usdt',
    'shib_usdc',
    'shib_usdt',
    'sol_usdc',
    'sol_usdt',
    'trx_usdc',
    'trx_usdt',
    'uni_usdc',
    'uni_usdt',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.private_reset_mmp_request as (
    "index_name" deribit.private_reset_mmp_request_index_name,
    "mmp_group" text
);

comment on column deribit.private_reset_mmp_request."index_name" is '(Required) Index identifier of derivative instrument on the platform';
comment on column deribit.private_reset_mmp_request."mmp_group" is 'Specifies the MMP group for which limits are being reset. If this parameter is omitted, the endpoint resets the traditional (no group) MMP limits';

create type deribit.private_reset_mmp_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_reset_mmp_response."id" is 'The id that was sent in the request';
comment on column deribit.private_reset_mmp_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_reset_mmp_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_reset_mmp(
    "index_name" deribit.private_reset_mmp_request_index_name,
    "mmp_group" text default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "index_name",
            "mmp_group"
        )::deribit.private_reset_mmp_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/reset_mmp'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_reset_mmp_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_reset_mmp is 'Reset MMP';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_sell_request_otoco_config_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_sell_request_otoco_config_type as enum (
    'limit',
    'market',
    'market_limit',
    'stop_limit',
    'stop_market',
    'take_limit',
    'take_market',
    'trailing_stop'
);

create type deribit.private_sell_request_otoco_config_time_in_force as enum (
    'fill_or_kill',
    'good_til_cancelled',
    'good_til_day',
    'immediate_or_cancel'
);

create type deribit.private_sell_request_otoco_config_trigger as enum (
    'index_price',
    'last_price',
    'mark_price'
);

create type deribit.private_sell_request_type as enum (
    'limit',
    'market',
    'market_limit',
    'stop_limit',
    'stop_market',
    'take_limit',
    'take_market',
    'trailing_stop'
);

create type deribit.private_sell_request_time_in_force as enum (
    'fill_or_kill',
    'good_til_cancelled',
    'good_til_day',
    'immediate_or_cancel'
);

create type deribit.private_sell_request_trigger as enum (
    'index_price',
    'last_price',
    'mark_price'
);

create type deribit.private_sell_request_advanced as enum (
    'implv',
    'usd'
);

create type deribit.private_sell_request_linked_order_type as enum (
    'one_cancels_other',
    'one_triggers_one_cancels_other',
    'one_triggers_other'
);

create type deribit.private_sell_request_trigger_fill_condition as enum (
    'complete_fill',
    'first_hit',
    'incremental'
);

create type deribit.private_sell_request_otoco_config as (
    "amount" double precision,
    "direction" deribit.private_sell_request_otoco_config_direction,
    "type" deribit.private_sell_request_otoco_config_type,
    "label" text,
    "price" double precision,
    "reduce_only" boolean,
    "time_in_force" deribit.private_sell_request_otoco_config_time_in_force,
    "post_only" boolean,
    "reject_post_only" boolean,
    "trigger_price" double precision,
    "trigger_offset" double precision,
    "trigger" deribit.private_sell_request_otoco_config_trigger
);

comment on column deribit.private_sell_request_otoco_config."amount" is 'It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_sell_request_otoco_config."direction" is '(Required) Direction of trade from the maker perspective';
comment on column deribit.private_sell_request_otoco_config."type" is 'The order type, default: "limit"';
comment on column deribit.private_sell_request_otoco_config."label" is 'user defined label for the order (maximum 64 characters)';
comment on column deribit.private_sell_request_otoco_config."price" is 'The order price in base currency (Only for limit and stop_limit orders) When adding an order with advanced=usd, the field price should be the option price value in USD. When adding an order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_sell_request_otoco_config."reduce_only" is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_sell_request_otoco_config."time_in_force" is 'Specifies how long the order remains in effect. Default "good_til_cancelled" "good_til_cancelled" - unfilled order remains in order book until cancelled "good_til_day" - unfilled order remains in order book till the end of the trading session "fill_or_kill" - execute a transaction immediately and completely or not at all "immediate_or_cancel" - execute a transaction immediately, and any portion of the order that cannot be immediately filled is cancelled';
comment on column deribit.private_sell_request_otoco_config."post_only" is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just below or above the spread (according to the direction of the order). Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_sell_request_otoco_config."reject_post_only" is 'If an order is considered post-only and this field is set to true then the order is put to the order book unmodified or the request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_sell_request_otoco_config."trigger_price" is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_sell_request_otoco_config."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered';
comment on column deribit.private_sell_request_otoco_config."trigger" is 'Defines the trigger type. Required for "Stop-Loss", "Take-Profit" and "Trailing" trigger orders';

create type deribit.private_sell_request as (
    "instrument_name" text,
    "amount" double precision,
    "contracts" double precision,
    "type" deribit.private_sell_request_type,
    "label" text,
    "price" double precision,
    "time_in_force" deribit.private_sell_request_time_in_force,
    "max_show" double precision,
    "post_only" boolean,
    "reject_post_only" boolean,
    "reduce_only" boolean,
    "trigger_price" double precision,
    "trigger_offset" double precision,
    "trigger" deribit.private_sell_request_trigger,
    "advanced" deribit.private_sell_request_advanced,
    "mmp" boolean,
    "valid_until" bigint,
    "linked_order_type" deribit.private_sell_request_linked_order_type,
    "trigger_fill_condition" deribit.private_sell_request_trigger_fill_condition,
    "otoco_config" deribit.private_sell_request_otoco_config[]
);

comment on column deribit.private_sell_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_sell_request."amount" is 'It represents the requested order size. For perpetual and inverse futures the amount is in USD units. For linear futures it is the underlying base currency coin. For options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH. The amount is a mandatory parameter if contracts parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_sell_request."contracts" is 'It represents the requested order size in contract units and can be passed instead of amount. The contracts is a mandatory parameter if amount parameter is missing. If both contracts and amount parameter are passed they must match each other otherwise error is returned.';
comment on column deribit.private_sell_request."type" is 'The order type, default: "limit"';
comment on column deribit.private_sell_request."label" is 'user defined label for the order (maximum 64 characters)';
comment on column deribit.private_sell_request."price" is 'The order price in base currency (Only for limit and stop_limit orders) When adding an order with advanced=usd, the field price should be the option price value in USD. When adding an order with advanced=implv, the field price should be a value of implied volatility in percentages. For example, price=100, means implied volatility of 100%';
comment on column deribit.private_sell_request."time_in_force" is 'Specifies how long the order remains in effect. Default "good_til_cancelled" "good_til_cancelled" - unfilled order remains in order book until cancelled "good_til_day" - unfilled order remains in order book till the end of the trading session "fill_or_kill" - execute a transaction immediately and completely or not at all "immediate_or_cancel" - execute a transaction immediately, and any portion of the order that cannot be immediately filled is cancelled';
comment on column deribit.private_sell_request."max_show" is 'Maximum amount within an order to be shown to other customers, 0 for invisible order';
comment on column deribit.private_sell_request."post_only" is 'If true, the order is considered post-only. If the new price would cause the order to be filled immediately (as taker), the price will be changed to be just above the spread. Only valid in combination with time_in_force="good_til_cancelled"';
comment on column deribit.private_sell_request."reject_post_only" is 'If an order is considered post-only and this field is set to true then the order is put to the order book unmodified or the request is rejected. Only valid in combination with "post_only" set to true';
comment on column deribit.private_sell_request."reduce_only" is 'If true, the order is considered reduce-only which is intended to only reduce a current position';
comment on column deribit.private_sell_request."trigger_price" is 'Trigger price, required for trigger orders only (Stop-loss or Take-profit orders)';
comment on column deribit.private_sell_request."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered';
comment on column deribit.private_sell_request."trigger" is 'Defines the trigger type. Required for "Stop-Loss", "Take-Profit" and "Trailing" trigger orders';
comment on column deribit.private_sell_request."advanced" is 'Advanced option order type. (Only for options. Advanced USD orders are not supported for linear options.)';
comment on column deribit.private_sell_request."mmp" is 'Order MMP flag, only for order_type ''limit''';
comment on column deribit.private_sell_request."valid_until" is 'Timestamp, when provided server will start processing request in Matching Engine only before given timestamp, in other cases timed_out error will be responded. Remember that the given timestamp should be consistent with the server''s time, use /public/time method to obtain current server time.';
comment on column deribit.private_sell_request."linked_order_type" is 'The type of the linked order. "one_triggers_other" - Execution of primary order triggers the placement of one or more secondary orders. "one_cancels_other" - The execution of one order in a pair automatically cancels the other, typically used to set a stop-loss and take-profit simultaneously. "one_triggers_one_cancels_other" - The execution of a primary order triggers two secondary orders (a stop-loss and take-profit pair), where the execution of one secondary order cancels the other.';
comment on column deribit.private_sell_request."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_sell_request."otoco_config" is 'List of trades to create or cancel when this order is filled.';

create type deribit.private_sell_response_trade as (
    "timestamp" bigint,
    "label" text,
    "fee" double precision,
    "quote_id" text,
    "liquidity" text,
    "index_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "legs" text[],
    "trade_seq" bigint,
    "risk_reducing" boolean,
    "instrument_name" text,
    "fee_currency" text,
    "direction" text,
    "trade_id" text,
    "tick_direction" bigint,
    "profit_loss" double precision,
    "matching_id" text,
    "price" double precision,
    "reduce_only" text,
    "amount" double precision,
    "post_only" text,
    "liquidation" text,
    "combo_trade_id" double precision,
    "order_id" text,
    "block_trade_id" text,
    "order_type" text,
    "quote_set_id" text,
    "combo_id" text,
    "underlying_price" double precision,
    "contracts" double precision,
    "mark_price" double precision,
    "iv" double precision,
    "state" text,
    "advanced" text
);

comment on column deribit.private_sell_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.private_sell_response_trade."label" is 'User defined label (presented only when previously set for order by user)';
comment on column deribit.private_sell_response_trade."fee" is 'User''s fee in units of the specified fee_currency';
comment on column deribit.private_sell_response_trade."quote_id" is 'QuoteID of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_sell_response_trade."liquidity" is 'Describes what was role of users order: "M" when it was maker order, "T" when it was taker order';
comment on column deribit.private_sell_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.private_sell_response_trade."api" is 'true if user order was created with API';
comment on column deribit.private_sell_response_trade."mmp" is 'true if user order is MMP';
comment on column deribit.private_sell_response_trade."legs" is 'Optional field containing leg trades if trade is a combo trade (present when querying for only combo trades and in combo_trades events)';
comment on column deribit.private_sell_response_trade."trade_seq" is 'The sequence number of the trade within instrument';
comment on column deribit.private_sell_response_trade."risk_reducing" is 'true if user order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users)';
comment on column deribit.private_sell_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_sell_response_trade."fee_currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_sell_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.private_sell_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.private_sell_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.private_sell_response_trade."profit_loss" is 'Profit and loss in base currency.';
comment on column deribit.private_sell_response_trade."matching_id" is 'Always null';
comment on column deribit.private_sell_response_trade."price" is 'Price in base currency';
comment on column deribit.private_sell_response_trade."reduce_only" is 'true if user order is reduce-only';
comment on column deribit.private_sell_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_sell_response_trade."post_only" is 'true if user order is post-only';
comment on column deribit.private_sell_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.private_sell_response_trade."combo_trade_id" is 'Optional field containing combo trade identifier if the trade is a combo trade';
comment on column deribit.private_sell_response_trade."order_id" is 'Id of the user order (maker or taker), i.e. subscriber''s order id that took part in the trade';
comment on column deribit.private_sell_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.private_sell_response_trade."order_type" is 'Order type: "limit, "market", or "liquidation"';
comment on column deribit.private_sell_response_trade."quote_set_id" is 'QuoteSet of the user order (optional, present only for orders placed with private/mass_quote)';
comment on column deribit.private_sell_response_trade."combo_id" is 'Optional field containing combo instrument name if the trade is a combo trade';
comment on column deribit.private_sell_response_trade."underlying_price" is 'Underlying price for implied volatility calculations (Options only)';
comment on column deribit.private_sell_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.private_sell_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.private_sell_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.private_sell_response_trade."state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered" or "archive" (if order was archived)';
comment on column deribit.private_sell_response_trade."advanced" is 'Advanced type of user order: "usd" or "implv" (only for options; omitted if not applicable)';

create type deribit.private_sell_response_order as (
    "reject_post_only" boolean,
    "label" text,
    "quote_id" text,
    "order_state" text,
    "is_secondary_oto" boolean,
    "usd" double precision,
    "implv" double precision,
    "trigger_reference_price" double precision,
    "original_order_type" text,
    "oco_ref" text,
    "block_trade" boolean,
    "trigger_price" double precision,
    "api" boolean,
    "mmp" boolean,
    "oto_order_ids" text[],
    "trigger_order_id" text,
    "cancel_reason" text,
    "primary_order_id" text,
    "quote" boolean,
    "risk_reducing" boolean,
    "filled_amount" double precision,
    "instrument_name" text,
    "max_show" double precision,
    "app_name" text,
    "mmp_cancelled" boolean,
    "direction" text,
    "last_update_timestamp" bigint,
    "trigger_offset" double precision,
    "mmp_group" text,
    "price" text,
    "is_liquidation" boolean,
    "reduce_only" boolean,
    "amount" double precision,
    "is_primary_otoco" boolean,
    "post_only" boolean,
    "mobile" boolean,
    "trigger_fill_condition" text,
    "triggered" boolean,
    "order_id" text,
    "replaced" boolean,
    "order_type" text,
    "time_in_force" text,
    "auto_replaced" boolean,
    "quote_set_id" text,
    "contracts" double precision,
    "trigger" text,
    "web" boolean,
    "creation_timestamp" bigint,
    "is_rebalance" boolean,
    "average_price" double precision,
    "advanced" text
);

comment on column deribit.private_sell_response_order."reject_post_only" is 'true if order has reject_post_only flag (field is present only when post_only is true)';
comment on column deribit.private_sell_response_order."label" is 'User defined label (up to 64 characters)';
comment on column deribit.private_sell_response_order."quote_id" is 'The same QuoteID as supplied in the private/mass_quote request.';
comment on column deribit.private_sell_response_order."order_state" is 'Order state: "open", "filled", "rejected", "cancelled", "untriggered"';
comment on column deribit.private_sell_response_order."is_secondary_oto" is 'true if the order is an order that can be triggered by another order, otherwise not present.';
comment on column deribit.private_sell_response_order."usd" is 'Option price in USD (Only if advanced="usd")';
comment on column deribit.private_sell_response_order."implv" is 'Implied volatility in percent. (Only if advanced="implv")';
comment on column deribit.private_sell_response_order."trigger_reference_price" is 'The price of the given trigger at the time when the order was placed (Only for trailing trigger orders)';
comment on column deribit.private_sell_response_order."original_order_type" is 'Original order type. Optional field';
comment on column deribit.private_sell_response_order."oco_ref" is 'Unique reference that identifies a one_cancels_others (OCO) pair.';
comment on column deribit.private_sell_response_order."block_trade" is 'true if order made from block_trade trade, added only in that case.';
comment on column deribit.private_sell_response_order."trigger_price" is 'Trigger price (Only for future trigger orders)';
comment on column deribit.private_sell_response_order."api" is 'true if created with API';
comment on column deribit.private_sell_response_order."mmp" is 'true if the order is a MMP order, otherwise false.';
comment on column deribit.private_sell_response_order."oto_order_ids" is 'The Ids of the orders that will be triggered if the order is filled';
comment on column deribit.private_sell_response_order."trigger_order_id" is 'Id of the trigger order that created the order (Only for orders that were created by triggered orders).';
comment on column deribit.private_sell_response_order."cancel_reason" is 'Enumerated reason behind cancel "user_request", "autoliquidation", "cancel_on_disconnect", "risk_mitigation", "pme_risk_reduction" (portfolio margining risk reduction), "pme_account_locked" (portfolio margining account locked per currency), "position_locked", "mmp_trigger" (market maker protection), "mmp_config_curtailment" (market maker configured quantity decreased), "edit_post_only_reject" (cancelled on edit because of reject_post_only setting), "oco_other_closed" (the oco order linked to this order was closed), "oto_primary_closed" (the oto primary order that was going to trigger this order was cancelled), "settlement" (closed because of a settlement)';
comment on column deribit.private_sell_response_order."primary_order_id" is 'Unique order identifier';
comment on column deribit.private_sell_response_order."quote" is 'If order is a quote. Present only if true.';
comment on column deribit.private_sell_response_order."risk_reducing" is 'true if the order is marked by the platform as a risk reducing order (can apply only to orders placed by PM users), otherwise false.';
comment on column deribit.private_sell_response_order."filled_amount" is 'Filled amount of the order. For perpetual and futures the filled_amount is in USD units, for options - in units or corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_sell_response_order."instrument_name" is 'Unique instrument identifier';
comment on column deribit.private_sell_response_order."max_show" is 'Maximum amount within an order to be shown to other traders, 0 for invisible order.';
comment on column deribit.private_sell_response_order."app_name" is 'The name of the application that placed the order on behalf of the user (optional).';
comment on column deribit.private_sell_response_order."mmp_cancelled" is 'true if order was cancelled by mmp trigger (optional)';
comment on column deribit.private_sell_response_order."direction" is 'Direction: buy, or sell';
comment on column deribit.private_sell_response_order."last_update_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_sell_response_order."trigger_offset" is 'The maximum deviation from the price peak beyond which the order will be triggered (Only for trailing trigger orders)';
comment on column deribit.private_sell_response_order."mmp_group" is 'Name of the MMP group supplied in the private/mass_quote request.';
comment on column deribit.private_sell_response_order."price" is 'Price in base currency or "market_price" in case of open trigger market orders';
comment on column deribit.private_sell_response_order."is_liquidation" is 'Optional (not added for spot). true if order was automatically created during liquidation';
comment on column deribit.private_sell_response_order."reduce_only" is 'Optional (not added for spot). ''true for reduce-only orders only''';
comment on column deribit.private_sell_response_order."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.private_sell_response_order."is_primary_otoco" is 'true if the order is an order that can trigger an OCO pair, otherwise not present.';
comment on column deribit.private_sell_response_order."post_only" is 'true for post-only orders only';
comment on column deribit.private_sell_response_order."mobile" is 'optional field with value true added only when created with Mobile Application';
comment on column deribit.private_sell_response_order."trigger_fill_condition" is 'The fill condition of the linked order (Only for linked order types), default: first_hit. "first_hit" - any execution of the primary order will fully cancel/place all secondary orders. "complete_fill" - a complete execution (meaning the primary order no longer exists) will cancel/place the secondary orders. "incremental" - any fill of the primary order will cause proportional partial cancellation/placement of the secondary order. The amount that will be subtracted/added to the secondary order will be rounded down to the contract size.';
comment on column deribit.private_sell_response_order."triggered" is 'Whether the trigger order has been triggered';
comment on column deribit.private_sell_response_order."order_id" is 'Unique order identifier';
comment on column deribit.private_sell_response_order."replaced" is 'true if the order was edited (by user or - in case of advanced options orders - by pricing engine), otherwise false.';
comment on column deribit.private_sell_response_order."order_type" is 'Order type: "limit", "market", "stop_limit", "stop_market"';
comment on column deribit.private_sell_response_order."time_in_force" is 'Order time in force: "good_til_cancelled", "good_til_day", "fill_or_kill" or "immediate_or_cancel"';
comment on column deribit.private_sell_response_order."auto_replaced" is 'Options, advanced orders only - true if last modification of the order was performed by the pricing engine, otherwise false.';
comment on column deribit.private_sell_response_order."quote_set_id" is 'Identifier of the QuoteSet supplied in the private/mass_quote request.';
comment on column deribit.private_sell_response_order."contracts" is 'It represents the order size in contract units. (Optional, may be absent in historical data).';
comment on column deribit.private_sell_response_order."trigger" is 'Trigger type (only for trigger orders). Allowed values: "index_price", "mark_price", "last_price".';
comment on column deribit.private_sell_response_order."web" is 'true if created via Deribit frontend (optional)';
comment on column deribit.private_sell_response_order."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_sell_response_order."is_rebalance" is 'Optional (only for spot). true if order was automatically created during cross-collateral balance restoration';
comment on column deribit.private_sell_response_order."average_price" is 'Average fill price of the order';
comment on column deribit.private_sell_response_order."advanced" is 'advanced type: "usd" or "implv" (Only for options; field is omitted if not applicable).';

create type deribit.private_sell_response_result as (
    "order" deribit.private_sell_response_order,
    "trades" deribit.private_sell_response_trade[]
);

create type deribit.private_sell_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_sell_response_result
);

comment on column deribit.private_sell_response."id" is 'The id that was sent in the request';
comment on column deribit.private_sell_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_sell(
    "instrument_name" text,
    "amount" double precision default null,
    "contracts" double precision default null,
    "type" deribit.private_sell_request_type default null,
    "label" text default null,
    "price" double precision default null,
    "time_in_force" deribit.private_sell_request_time_in_force default null,
    "max_show" double precision default null,
    "post_only" boolean default null,
    "reject_post_only" boolean default null,
    "reduce_only" boolean default null,
    "trigger_price" double precision default null,
    "trigger_offset" double precision default null,
    "trigger" deribit.private_sell_request_trigger default null,
    "advanced" deribit.private_sell_request_advanced default null,
    "mmp" boolean default null,
    "valid_until" bigint default null,
    "linked_order_type" deribit.private_sell_request_linked_order_type default null,
    "trigger_fill_condition" deribit.private_sell_request_trigger_fill_condition default null,
    "otoco_config" deribit.private_sell_request_otoco_config[] default null
)
returns deribit.private_sell_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "amount",
            "contracts",
            "type",
            "label",
            "price",
            "time_in_force",
            "max_show",
            "post_only",
            "reject_post_only",
            "reduce_only",
            "trigger_price",
            "trigger_offset",
            "trigger",
            "advanced",
            "mmp",
            "valid_until",
            "linked_order_type",
            "trigger_fill_condition",
            "otoco_config"
        )::deribit.private_sell_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/sell'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_sell_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_sell is 'Places a sell order for an instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_send_rfq_request_side as enum (
    'buy',
    'sell'
);

create type deribit.private_send_rfq_request as (
    "instrument_name" text,
    "amount" double precision,
    "side" deribit.private_send_rfq_request_side
);

comment on column deribit.private_send_rfq_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_send_rfq_request."amount" is 'Amount';
comment on column deribit.private_send_rfq_request."side" is 'Side - buy or sell';

create type deribit.private_send_rfq_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_send_rfq_response."id" is 'The id that was sent in the request';
comment on column deribit.private_send_rfq_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_send_rfq_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_send_rfq(
    "instrument_name" text,
    "amount" double precision default null,
    "side" deribit.private_send_rfq_request_side default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "amount",
            "side"
        )::deribit.private_send_rfq_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/send_rfq'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_send_rfq_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_announcement_as_read_request as (
    "announcement_id" double precision
);

comment on column deribit.private_set_announcement_as_read_request."announcement_id" is '(Required) the ID of the announcement';

create type deribit.private_set_announcement_as_read_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_set_announcement_as_read_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_announcement_as_read_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_announcement_as_read_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_set_announcement_as_read(
    "announcement_id" double precision
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "announcement_id"
        )::deribit.private_set_announcement_as_read_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/set_announcement_as_read'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_set_announcement_as_read_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_set_announcement_as_read is 'Marks an announcement as read, so it will not be shown in get_new_announcements.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_disabled_trading_products_request as (
    "user_id" bigint,
    "trading_products" text[]
);

comment on column deribit.private_set_disabled_trading_products_request."user_id" is '(Required) Id of a (sub)account';
comment on column deribit.private_set_disabled_trading_products_request."trading_products" is '(Required) List of available trading products. Available products: perpetual, futures, options, future_combos, option_combos, spots';

create type deribit.private_set_disabled_trading_products_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_set_disabled_trading_products_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_disabled_trading_products_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_disabled_trading_products_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_set_disabled_trading_products(
    "user_id" bigint,
    "trading_products" text[]
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "user_id",
            "trading_products"
        )::deribit.private_set_disabled_trading_products_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/set_disabled_trading_products'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_set_disabled_trading_products_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_set_disabled_trading_products is 'Configure disabled trading products for subaccounts. Only main accounts can modify this for subaccounts.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_email_for_subaccount_request as (
    "sid" bigint,
    "email" text
);

comment on column deribit.private_set_email_for_subaccount_request."sid" is '(Required) The user id for the subaccount';
comment on column deribit.private_set_email_for_subaccount_request."email" is '(Required) The email address for the subaccount';

create type deribit.private_set_email_for_subaccount_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_set_email_for_subaccount_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_email_for_subaccount_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_for_subaccount_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_set_email_for_subaccount(
    "sid" bigint,
    "email" text
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "sid",
            "email"
        )::deribit.private_set_email_for_subaccount_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/set_email_for_subaccount'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_set_email_for_subaccount_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_set_email_for_subaccount is 'Assign an email address to a subaccount. User will receive an email with a confirmation link.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_email_language_request as (
    "language" text
);

comment on column deribit.private_set_email_language_request."language" is '(Required) The abbreviated language name. Valid values include "en", "ko", "zh", "ja", "ru"';

create type deribit.private_set_email_language_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_set_email_language_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_email_language_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_email_language_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_set_email_language(
    "language" text
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "language"
        )::deribit.private_set_email_language_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/set_email_language'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_set_email_language_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_set_email_language is 'Changes the language to be used for emails.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_mmp_config_request_index_name as enum (
    'ada_usdc',
    'ada_usdt',
    'algo_usdc',
    'algo_usdt',
    'avax_usdc',
    'avax_usdt',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usdc',
    'doge_usdt',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usdc',
    'link_usdt',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usdc',
    'matic_usdt',
    'near_usdc',
    'near_usdt',
    'shib_usdc',
    'shib_usdt',
    'sol_usdc',
    'sol_usdt',
    'trx_usdc',
    'trx_usdt',
    'uni_usdc',
    'uni_usdt',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.private_set_mmp_config_request as (
    "index_name" deribit.private_set_mmp_config_request_index_name,
    "interval" bigint,
    "frozen_time" bigint,
    "mmp_group" text,
    "quantity_limit" double precision,
    "delta_limit" double precision
);

comment on column deribit.private_set_mmp_config_request."index_name" is '(Required) Index identifier of derivative instrument on the platform';
comment on column deribit.private_set_mmp_config_request."interval" is '(Required) MMP Interval in seconds, if set to 0 MMP is removed';
comment on column deribit.private_set_mmp_config_request."frozen_time" is '(Required) MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_set_mmp_config_request."mmp_group" is 'Designates the MMP group for which the configuration is being set. If the specified group is already associated with a different index_name, an error is returned. This parameter enables distinct configurations for each MMP group, linked to particular index_name';
comment on column deribit.private_set_mmp_config_request."quantity_limit" is 'Quantity limit, positive value';
comment on column deribit.private_set_mmp_config_request."delta_limit" is 'Delta limit, positive value';

create type deribit.private_set_mmp_config_response_result as (
    "delta_limit" double precision,
    "frozen_time" bigint,
    "index_name" text,
    "interval" bigint,
    "mmp_group" text,
    "quantity_limit" double precision
);

comment on column deribit.private_set_mmp_config_response_result."delta_limit" is 'Delta limit';
comment on column deribit.private_set_mmp_config_response_result."frozen_time" is 'MMP frozen time in seconds, if set to 0 manual reset is required';
comment on column deribit.private_set_mmp_config_response_result."index_name" is 'Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.private_set_mmp_config_response_result."interval" is 'MMP Interval in seconds, if set to 0 MMP is disabled';
comment on column deribit.private_set_mmp_config_response_result."mmp_group" is 'Specified MMP Group';
comment on column deribit.private_set_mmp_config_response_result."quantity_limit" is 'Quantity limit';

create type deribit.private_set_mmp_config_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_set_mmp_config_response_result[]
);

comment on column deribit.private_set_mmp_config_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_mmp_config_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_set_mmp_config(
    "index_name" deribit.private_set_mmp_config_request_index_name,
    "interval" bigint,
    "frozen_time" bigint,
    "mmp_group" text default null,
    "quantity_limit" double precision default null,
    "delta_limit" double precision default null
)
returns setof deribit.private_set_mmp_config_response_result
language sql
as $$
    
    with request as (
        select row(
            "index_name",
            "interval",
            "frozen_time",
            "mmp_group",
            "quantity_limit",
            "delta_limit"
        )::deribit.private_set_mmp_config_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/set_mmp_config'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_set_mmp_config_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."delta_limit"::double precision,
        (b)."frozen_time"::bigint,
        (b)."index_name"::text,
        (b)."interval"::bigint,
        (b)."mmp_group"::text,
        (b)."quantity_limit"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_set_mmp_config is 'Set config for MMP - triggers MMP reset';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_set_self_trading_config_request_mode as enum (
    'cancel_maker',
    'reject_taker'
);

create type deribit.private_set_self_trading_config_request as (
    "mode" deribit.private_set_self_trading_config_request_mode,
    "extended_to_subaccounts" boolean
);

comment on column deribit.private_set_self_trading_config_request."mode" is '(Required) Self trading prevention behavior: reject_taker (reject the incoming order), cancel_maker (cancel the matched order in the book)';
comment on column deribit.private_set_self_trading_config_request."extended_to_subaccounts" is '(Required) If value is true trading is prevented between subaccounts of given account, otherwise they are treated separately';

create type deribit.private_set_self_trading_config_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_set_self_trading_config_response."id" is 'The id that was sent in the request';
comment on column deribit.private_set_self_trading_config_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_self_trading_config_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_set_self_trading_config(
    "mode" deribit.private_set_self_trading_config_request_mode,
    "extended_to_subaccounts" boolean
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "mode",
            "extended_to_subaccounts"
        )::deribit.private_set_self_trading_config_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/set_self_trading_config'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_set_self_trading_config_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_set_self_trading_config is 'Configure self trading behavior';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_simulate_block_trade_request_trade_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_simulate_block_trade_request_role as enum (
    'maker',
    'taker'
);

create type deribit.private_simulate_block_trade_request_trade as (
    "instrument_name" text,
    "price" double precision,
    "amount" double precision,
    "direction" deribit.private_simulate_block_trade_request_trade_direction
);

comment on column deribit.private_simulate_block_trade_request_trade."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_simulate_block_trade_request_trade."price" is '(Required) Price for trade';
comment on column deribit.private_simulate_block_trade_request_trade."amount" is 'It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_simulate_block_trade_request_trade."direction" is '(Required) Direction of trade from the maker perspective';

create type deribit.private_simulate_block_trade_request as (
    "role" deribit.private_simulate_block_trade_request_role,
    "trades" deribit.private_simulate_block_trade_request_trade[]
);

comment on column deribit.private_simulate_block_trade_request."role" is 'Describes if user wants to be maker or taker of trades';
comment on column deribit.private_simulate_block_trade_request."trades" is '(Required) List of trades for block trade';

create type deribit.private_simulate_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" boolean
);

comment on column deribit.private_simulate_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_simulate_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_simulate_block_trade_response."result" is 'true if block trade can be executed, false otherwise';

create function deribit.private_simulate_block_trade(
    "trades" deribit.private_simulate_block_trade_request_trade[],
    "role" deribit.private_simulate_block_trade_request_role default null
)
returns boolean
language sql
as $$
    
    with request as (
        select row(
            "role",
            "trades"
        )::deribit.private_simulate_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/simulate_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_simulate_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_simulate_block_trade is 'Checks if a block trade can be executed';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_simulate_portfolio_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_simulate_portfolio_request as (
    "currency" deribit.private_simulate_portfolio_request_currency,
    "add_positions" boolean,
    "simulated_positions" jsonb
);

comment on column deribit.private_simulate_portfolio_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_simulate_portfolio_request."add_positions" is 'If true, adds simulated positions to current positions, otherwise uses only simulated positions. By default true';
comment on column deribit.private_simulate_portfolio_request."simulated_positions" is 'Object with positions in following form: {InstrumentName1: Position1, InstrumentName2: Position2...}, for example {"BTC-PERPETUAL": -1000.0} (or corresponding URI-encoding for GET). For futures in USD, for options in base currency.';

create type deribit.private_simulate_portfolio_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" jsonb
);

comment on column deribit.private_simulate_portfolio_response."id" is 'The id that was sent in the request';
comment on column deribit.private_simulate_portfolio_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_simulate_portfolio_response."result" is 'PM details';

create function deribit.private_simulate_portfolio(
    "currency" deribit.private_simulate_portfolio_request_currency,
    "add_positions" boolean default null,
    "simulated_positions" jsonb default null
)
returns jsonb
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "add_positions",
            "simulated_positions"
        )::deribit.private_simulate_portfolio_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/simulate_portfolio'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_simulate_portfolio_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_simulate_portfolio is 'Calculates portfolio margin info for simulated position or current position of the user. This request has a special restricted rate limit (not more than once per a second).';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_submit_transfer_between_subaccounts_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_submit_transfer_between_subaccounts_request as (
    "currency" deribit.private_submit_transfer_between_subaccounts_request_currency,
    "amount" double precision,
    "destination" bigint,
    "source" bigint
);

comment on column deribit.private_submit_transfer_between_subaccounts_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_submit_transfer_between_subaccounts_request."amount" is '(Required) Amount of funds to be transferred';
comment on column deribit.private_submit_transfer_between_subaccounts_request."destination" is '(Required) Id of destination subaccount. Can be found in My Account >> Subaccounts tab';
comment on column deribit.private_submit_transfer_between_subaccounts_request."source" is 'Id of the source (sub)account. Can be found in My Account >> Subaccounts tab. By default, it is the Id of the account which made the request. However, if a different "source" is specified, the user must possess the mainaccount scope, and only other subaccounts can be designated as the source.';

create type deribit.private_submit_transfer_between_subaccounts_response_result as (
    "amount" double precision,
    "created_timestamp" bigint,
    "currency" text,
    "direction" text,
    "id" bigint,
    "other_side" text,
    "state" text,
    "type" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_submit_transfer_between_subaccounts_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."direction" is 'Transfer direction';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."id" is 'Id of transfer';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_submit_transfer_between_subaccounts_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_submit_transfer_between_subaccounts_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_submit_transfer_between_subaccounts_response_result
);

comment on column deribit.private_submit_transfer_between_subaccounts_response."id" is 'The id that was sent in the request';
comment on column deribit.private_submit_transfer_between_subaccounts_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_submit_transfer_between_subaccounts(
    "currency" deribit.private_submit_transfer_between_subaccounts_request_currency,
    "amount" double precision,
    "destination" bigint,
    "source" bigint default null
)
returns deribit.private_submit_transfer_between_subaccounts_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "amount",
            "destination",
            "source"
        )::deribit.private_submit_transfer_between_subaccounts_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/submit_transfer_between_subaccounts'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_submit_transfer_between_subaccounts_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_submit_transfer_between_subaccounts is 'Transfer funds between two (sub)accounts.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_submit_transfer_to_subaccount_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_submit_transfer_to_subaccount_request as (
    "currency" deribit.private_submit_transfer_to_subaccount_request_currency,
    "amount" double precision,
    "destination" bigint
);

comment on column deribit.private_submit_transfer_to_subaccount_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_submit_transfer_to_subaccount_request."amount" is '(Required) Amount of funds to be transferred';
comment on column deribit.private_submit_transfer_to_subaccount_request."destination" is '(Required) Id of destination subaccount. Can be found in My Account >> Subaccounts tab';

create type deribit.private_submit_transfer_to_subaccount_response_result as (
    "amount" double precision,
    "created_timestamp" bigint,
    "currency" text,
    "direction" text,
    "id" bigint,
    "other_side" text,
    "state" text,
    "type" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_submit_transfer_to_subaccount_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."direction" is 'Transfer direction';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."id" is 'Id of transfer';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_submit_transfer_to_subaccount_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_submit_transfer_to_subaccount_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_submit_transfer_to_subaccount_response_result
);

comment on column deribit.private_submit_transfer_to_subaccount_response."id" is 'The id that was sent in the request';
comment on column deribit.private_submit_transfer_to_subaccount_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_submit_transfer_to_subaccount(
    "currency" deribit.private_submit_transfer_to_subaccount_request_currency,
    "amount" double precision,
    "destination" bigint
)
returns deribit.private_submit_transfer_to_subaccount_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "amount",
            "destination"
        )::deribit.private_submit_transfer_to_subaccount_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/submit_transfer_to_subaccount'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_submit_transfer_to_subaccount_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_submit_transfer_to_subaccount is 'Transfer funds to subaccount.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_submit_transfer_to_user_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_submit_transfer_to_user_request as (
    "currency" deribit.private_submit_transfer_to_user_request_currency,
    "amount" double precision,
    "destination" text
);

comment on column deribit.private_submit_transfer_to_user_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_submit_transfer_to_user_request."amount" is '(Required) Amount of funds to be transferred';
comment on column deribit.private_submit_transfer_to_user_request."destination" is '(Required) Destination wallet''s address taken from address book';

create type deribit.private_submit_transfer_to_user_response_result as (
    "amount" double precision,
    "created_timestamp" bigint,
    "currency" text,
    "direction" text,
    "id" bigint,
    "other_side" text,
    "state" text,
    "type" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_submit_transfer_to_user_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_submit_transfer_to_user_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_submit_transfer_to_user_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_submit_transfer_to_user_response_result."direction" is 'Transfer direction';
comment on column deribit.private_submit_transfer_to_user_response_result."id" is 'Id of transfer';
comment on column deribit.private_submit_transfer_to_user_response_result."other_side" is 'For transfer from/to subaccount returns this subaccount name, for transfer to other account returns address, for transfer from other account returns that accounts username.';
comment on column deribit.private_submit_transfer_to_user_response_result."state" is 'Transfer state, allowed values : prepared, confirmed, cancelled, waiting_for_admin, insufficient_funds, withdrawal_limit otherwise rejection reason';
comment on column deribit.private_submit_transfer_to_user_response_result."type" is 'Type of transfer: user - sent to user, subaccount - sent to subaccount';
comment on column deribit.private_submit_transfer_to_user_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_submit_transfer_to_user_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_submit_transfer_to_user_response_result
);

comment on column deribit.private_submit_transfer_to_user_response."id" is 'The id that was sent in the request';
comment on column deribit.private_submit_transfer_to_user_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_submit_transfer_to_user(
    "currency" deribit.private_submit_transfer_to_user_request_currency,
    "amount" double precision,
    "destination" text
)
returns deribit.private_submit_transfer_to_user_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "amount",
            "destination"
        )::deribit.private_submit_transfer_to_user_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/submit_transfer_to_user'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_submit_transfer_to_user_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_submit_transfer_to_user is 'Transfer funds to another user.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_toggle_notifications_from_subaccount_request as (
    "sid" bigint,
    "state" boolean
);

comment on column deribit.private_toggle_notifications_from_subaccount_request."sid" is '(Required) The user id for the subaccount';
comment on column deribit.private_toggle_notifications_from_subaccount_request."state" is '(Required) enable (true) or disable (false) notifications';

create type deribit.private_toggle_notifications_from_subaccount_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_toggle_notifications_from_subaccount_response."id" is 'The id that was sent in the request';
comment on column deribit.private_toggle_notifications_from_subaccount_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_toggle_notifications_from_subaccount_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_toggle_notifications_from_subaccount(
    "sid" bigint,
    "state" boolean
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "sid",
            "state"
        )::deribit.private_toggle_notifications_from_subaccount_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/toggle_notifications_from_subaccount'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_toggle_notifications_from_subaccount_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_toggle_notifications_from_subaccount is 'Enable or disable sending of notifications for the subaccount.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_toggle_portfolio_margining_request as (
    "user_id" bigint,
    "enabled" boolean,
    "dry_run" boolean
);

comment on column deribit.private_toggle_portfolio_margining_request."user_id" is 'Id of a (sub)account - by default current user id is used';
comment on column deribit.private_toggle_portfolio_margining_request."enabled" is '(Required) Whether PM or SM should be enabled - PM while true, SM otherwise';
comment on column deribit.private_toggle_portfolio_margining_request."dry_run" is 'If true request returns the result without switching the margining model. Default: false';

create type deribit.private_toggle_portfolio_margining_response_old_state as (
    "available_balance" double precision,
    "initial_margin_rate" double precision,
    "maintenance_margin_rate" double precision
);

comment on column deribit.private_toggle_portfolio_margining_response_old_state."available_balance" is 'Available balance before change';
comment on column deribit.private_toggle_portfolio_margining_response_old_state."initial_margin_rate" is 'Initial margin rate before change';
comment on column deribit.private_toggle_portfolio_margining_response_old_state."maintenance_margin_rate" is 'Maintenance margin rate before change';

create type deribit.private_toggle_portfolio_margining_response_new_state as (
    "available_balance" double precision,
    "initial_margin_rate" double precision,
    "maintenance_margin_rate" double precision
);

comment on column deribit.private_toggle_portfolio_margining_response_new_state."available_balance" is 'Available balance after change';
comment on column deribit.private_toggle_portfolio_margining_response_new_state."initial_margin_rate" is 'Initial margin rate after change';
comment on column deribit.private_toggle_portfolio_margining_response_new_state."maintenance_margin_rate" is 'Maintenance margin rate after change';

create type deribit.private_toggle_portfolio_margining_response_result as (
    "currency" text,
    "new_state" deribit.private_toggle_portfolio_margining_response_new_state,
    "old_state" deribit.private_toggle_portfolio_margining_response_old_state
);

comment on column deribit.private_toggle_portfolio_margining_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_toggle_portfolio_margining_response_result."new_state" is 'Represents portfolio state after change';
comment on column deribit.private_toggle_portfolio_margining_response_result."old_state" is 'Represents portfolio state before change';

create type deribit.private_toggle_portfolio_margining_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_toggle_portfolio_margining_response_result[]
);

comment on column deribit.private_toggle_portfolio_margining_response."id" is 'The id that was sent in the request';
comment on column deribit.private_toggle_portfolio_margining_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_toggle_portfolio_margining(
    "enabled" boolean,
    "user_id" bigint default null,
    "dry_run" boolean default null
)
returns setof deribit.private_toggle_portfolio_margining_response_result
language sql
as $$
    
    with request as (
        select row(
            "user_id",
            "enabled",
            "dry_run"
        )::deribit.private_toggle_portfolio_margining_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/toggle_portfolio_margining'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.private_toggle_portfolio_margining_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."currency"::text,
        (b)."new_state"::deribit.private_toggle_portfolio_margining_response_new_state,
        (b)."old_state"::deribit.private_toggle_portfolio_margining_response_old_state
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_toggle_portfolio_margining is 'Toggle between SM and PM models';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_toggle_subaccount_login_request_state as enum (
    'disable',
    'enable'
);

create type deribit.private_toggle_subaccount_login_request as (
    "sid" bigint,
    "state" deribit.private_toggle_subaccount_login_request_state
);

comment on column deribit.private_toggle_subaccount_login_request."sid" is '(Required) The user id for the subaccount';
comment on column deribit.private_toggle_subaccount_login_request."state" is '(Required) enable or disable login.';

create type deribit.private_toggle_subaccount_login_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text
);

comment on column deribit.private_toggle_subaccount_login_response."id" is 'The id that was sent in the request';
comment on column deribit.private_toggle_subaccount_login_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_toggle_subaccount_login_response."result" is 'Result of method execution. ok in case of success';

create function deribit.private_toggle_subaccount_login(
    "sid" bigint,
    "state" deribit.private_toggle_subaccount_login_request_state
)
returns text
language sql
as $$
    
    with request as (
        select row(
            "sid",
            "state"
        )::deribit.private_toggle_subaccount_login_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/toggle_subaccount_login'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_toggle_subaccount_login_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_toggle_subaccount_login is 'Enable or disable login for a subaccount. If login is disabled and a session for the subaccount exists, this session will be terminated.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_verify_block_trade_request_trade_direction as enum (
    'buy',
    'sell'
);

create type deribit.private_verify_block_trade_request_role as enum (
    'maker',
    'taker'
);

create type deribit.private_verify_block_trade_request_trade as (
    "instrument_name" text,
    "price" double precision,
    "amount" double precision,
    "direction" deribit.private_verify_block_trade_request_trade_direction
);

comment on column deribit.private_verify_block_trade_request_trade."instrument_name" is '(Required) Instrument name';
comment on column deribit.private_verify_block_trade_request_trade."price" is '(Required) Price for trade';
comment on column deribit.private_verify_block_trade_request_trade."amount" is 'It represents the requested trade size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH';
comment on column deribit.private_verify_block_trade_request_trade."direction" is '(Required) Direction of trade from the maker perspective';

create type deribit.private_verify_block_trade_request as (
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_verify_block_trade_request_role,
    "trades" deribit.private_verify_block_trade_request_trade[]
);

comment on column deribit.private_verify_block_trade_request."timestamp" is '(Required) Timestamp, shared with other party (milliseconds since the UNIX epoch)';
comment on column deribit.private_verify_block_trade_request."nonce" is '(Required) Nonce, shared with other party';
comment on column deribit.private_verify_block_trade_request."role" is '(Required) Describes if user wants to be maker or taker of trades';
comment on column deribit.private_verify_block_trade_request."trades" is '(Required) List of trades for block trade';

create type deribit.private_verify_block_trade_response_result as (
    "signature" text
);

comment on column deribit.private_verify_block_trade_response_result."signature" is 'Signature of block trade It is valid only for 5 minutes âaroundâ given timestamp';

create type deribit.private_verify_block_trade_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_verify_block_trade_response_result
);

comment on column deribit.private_verify_block_trade_response."id" is 'The id that was sent in the request';
comment on column deribit.private_verify_block_trade_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_verify_block_trade(
    "timestamp" bigint,
    "nonce" text,
    "role" deribit.private_verify_block_trade_request_role,
    "trades" deribit.private_verify_block_trade_request_trade[]
)
returns deribit.private_verify_block_trade_response_result
language sql
as $$
    
    with request as (
        select row(
            "timestamp",
            "nonce",
            "role",
            "trades"
        )::deribit.private_verify_block_trade_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/verify_block_trade'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_verify_block_trade_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_verify_block_trade is 'Verifies and creates block trade signature';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_withdraw_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.private_withdraw_request_priority as enum (
    'extreme_high',
    'high',
    'insane',
    'low',
    'mid',
    'very_high',
    'very_low'
);

create type deribit.private_withdraw_request as (
    "currency" deribit.private_withdraw_request_currency,
    "address" text,
    "amount" double precision,
    "priority" deribit.private_withdraw_request_priority
);

comment on column deribit.private_withdraw_request."currency" is '(Required) The currency symbol';
comment on column deribit.private_withdraw_request."address" is '(Required) Address in currency format, it must be in address book';
comment on column deribit.private_withdraw_request."amount" is '(Required) Amount of funds to be withdrawn';
comment on column deribit.private_withdraw_request."priority" is 'Withdrawal priority, optional for BTC, default: high';

create type deribit.private_withdraw_response_result as (
    "address" text,
    "amount" double precision,
    "confirmed_timestamp" bigint,
    "created_timestamp" bigint,
    "currency" text,
    "fee" double precision,
    "id" bigint,
    "priority" double precision,
    "state" text,
    "transaction_id" text,
    "updated_timestamp" bigint
);

comment on column deribit.private_withdraw_response_result."address" is 'Address in proper format for currency';
comment on column deribit.private_withdraw_response_result."amount" is 'Amount of funds in given currency';
comment on column deribit.private_withdraw_response_result."confirmed_timestamp" is 'The timestamp (milliseconds since the Unix epoch) of withdrawal confirmation, null when not confirmed';
comment on column deribit.private_withdraw_response_result."created_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.private_withdraw_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_withdraw_response_result."fee" is 'Fee in currency';
comment on column deribit.private_withdraw_response_result."id" is 'Withdrawal id in Deribit system';
comment on column deribit.private_withdraw_response_result."priority" is 'Id of priority level';
comment on column deribit.private_withdraw_response_result."state" is 'Withdrawal state, allowed values : unconfirmed, confirmed, cancelled, completed, interrupted, rejected';
comment on column deribit.private_withdraw_response_result."transaction_id" is 'Transaction id in proper format for currency, null if id is not available';
comment on column deribit.private_withdraw_response_result."updated_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.private_withdraw_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.private_withdraw_response_result
);

comment on column deribit.private_withdraw_response."id" is 'The id that was sent in the request';
comment on column deribit.private_withdraw_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.private_withdraw(
    "currency" deribit.private_withdraw_request_currency,
    "address" text,
    "amount" double precision,
    "priority" deribit.private_withdraw_request_priority default null
)
returns deribit.private_withdraw_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "address",
            "amount",
            "priority"
        )::deribit.private_withdraw_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := deribit.get_auth(),
            url := '/private/withdraw'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.private_withdraw_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.private_withdraw is 'Creates a new withdrawal request';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_auth_request_grant_type as enum (
    'client_credentials',
    'client_signature',
    'refresh_token'
);

create type deribit.public_auth_request as (
    "grant_type" deribit.public_auth_request_grant_type,
    "client_id" text,
    "client_secret" text,
    "refresh_token" text,
    "timestamp" bigint,
    "signature" text,
    "nonce" text,
    "data" text,
    "state" text,
    "scope" text
);

comment on column deribit.public_auth_request."grant_type" is '(Required) Method of authentication';
comment on column deribit.public_auth_request."client_id" is '(Required) Required for grant type client_credentials and client_signature';
comment on column deribit.public_auth_request."client_secret" is '(Required) Required for grant type client_credentials';
comment on column deribit.public_auth_request."refresh_token" is '(Required) Required for grant type refresh_token';
comment on column deribit.public_auth_request."timestamp" is '(Required) Required for grant type client_signature, provides time when request has been generated (milliseconds since the UNIX epoch)';
comment on column deribit.public_auth_request."signature" is '(Required) Required for grant type client_signature; it''s a cryptographic signature calculated over provided fields using user secret key. The signature should be calculated as an HMAC (Hash-based Message Authentication Code) with SHA256 hash algorithm';
comment on column deribit.public_auth_request."nonce" is 'Optional for grant type client_signature; delivers user generated initialization vector for the server token';
comment on column deribit.public_auth_request."data" is 'Optional for grant type client_signature; contains any user specific value';
comment on column deribit.public_auth_request."state" is 'Will be passed back in the response';
comment on column deribit.public_auth_request."scope" is 'Describes type of the access for assigned token, possible values: connection, session:name, trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], expires:NUMBER, ip:ADDR. Details are elucidated in Access scope';

create type deribit.public_auth_response_result as (
    "access_token" text,
    "enabled_features" text[],
    "expires_in" bigint,
    "refresh_token" text,
    "scope" text,
    "sid" text,
    "state" text,
    "token_type" text
);

comment on column deribit.public_auth_response_result."enabled_features" is 'List of enabled advanced on-key features. Available options:  - restricted_block_trades: Limit the block_trade read the scope of the API key to block trades that have been made using this specific API key  - block_trade_approval: Block trades created using this API key require additional user approval';
comment on column deribit.public_auth_response_result."expires_in" is 'Token lifetime in seconds';
comment on column deribit.public_auth_response_result."refresh_token" is 'Can be used to request a new token (with a new lifetime)';
comment on column deribit.public_auth_response_result."scope" is 'Type of the access for assigned token';
comment on column deribit.public_auth_response_result."sid" is 'Optional Session id';
comment on column deribit.public_auth_response_result."state" is 'Copied from the input (if applicable)';
comment on column deribit.public_auth_response_result."token_type" is 'Authorization type, allowed value - bearer';

create type deribit.public_auth_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_auth_response_result
);

comment on column deribit.public_auth_response."id" is 'The id that was sent in the request';
comment on column deribit.public_auth_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_auth(
    "grant_type" deribit.public_auth_request_grant_type,
    "client_id" text,
    "client_secret" text,
    "refresh_token" text,
    "timestamp" bigint,
    "signature" text,
    "nonce" text default null,
    "data" text default null,
    "state" text default null,
    "scope" text default null
)
returns deribit.public_auth_response_result
language sql
as $$
    
    with request as (
        select row(
            "grant_type",
            "client_id",
            "client_secret",
            "refresh_token",
            "timestamp",
            "signature",
            "nonce",
            "data",
            "state",
            "scope"
        )::deribit.public_auth_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/auth'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_auth_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_auth is 'Retrieve an Oauth access token, to be used for authentication of ''private'' requests.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_exchange_token_request as (
    "refresh_token" text,
    "subject_id" bigint
);

comment on column deribit.public_exchange_token_request."refresh_token" is '(Required) Refresh token';
comment on column deribit.public_exchange_token_request."subject_id" is '(Required) New subject id';

create type deribit.public_exchange_token_response_result as (
    "access_token" text,
    "expires_in" bigint,
    "refresh_token" text,
    "scope" text,
    "sid" text,
    "token_type" text
);

comment on column deribit.public_exchange_token_response_result."expires_in" is 'Token lifetime in seconds';
comment on column deribit.public_exchange_token_response_result."refresh_token" is 'Can be used to request a new token (with a new lifetime)';
comment on column deribit.public_exchange_token_response_result."scope" is 'Type of the access for assigned token';
comment on column deribit.public_exchange_token_response_result."sid" is 'Optional Session id';
comment on column deribit.public_exchange_token_response_result."token_type" is 'Authorization type, allowed value - bearer';

create type deribit.public_exchange_token_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_exchange_token_response_result
);

comment on column deribit.public_exchange_token_response."id" is 'The id that was sent in the request';
comment on column deribit.public_exchange_token_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_exchange_token(
    "refresh_token" text,
    "subject_id" bigint
)
returns deribit.public_exchange_token_response_result
language sql
as $$
    
    with request as (
        select row(
            "refresh_token",
            "subject_id"
        )::deribit.public_exchange_token_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/exchange_token'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_exchange_token_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_exchange_token is 'Generates a token for a new subject id. This method can be used to switch between subaccounts.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_fork_token_request as (
    "refresh_token" text,
    "session_name" text
);

comment on column deribit.public_fork_token_request."refresh_token" is '(Required) Refresh token';
comment on column deribit.public_fork_token_request."session_name" is '(Required) New session name';

create type deribit.public_fork_token_response_result as (
    "access_token" text,
    "expires_in" bigint,
    "refresh_token" text,
    "scope" text,
    "sid" text,
    "token_type" text
);

comment on column deribit.public_fork_token_response_result."expires_in" is 'Token lifetime in seconds';
comment on column deribit.public_fork_token_response_result."refresh_token" is 'Can be used to request a new token (with a new lifetime)';
comment on column deribit.public_fork_token_response_result."scope" is 'Type of the access for assigned token';
comment on column deribit.public_fork_token_response_result."sid" is 'Optional Session id';
comment on column deribit.public_fork_token_response_result."token_type" is 'Authorization type, allowed value - bearer';

create type deribit.public_fork_token_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_fork_token_response_result
);

comment on column deribit.public_fork_token_response."id" is 'The id that was sent in the request';
comment on column deribit.public_fork_token_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_fork_token(
    "refresh_token" text,
    "session_name" text
)
returns deribit.public_fork_token_response_result
language sql
as $$
    
    with request as (
        select row(
            "refresh_token",
            "session_name"
        )::deribit.public_fork_token_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/fork_token'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_fork_token_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_fork_token is 'Generates a token for a new named session. This method can be used only with session scoped tokens.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_announcements_request as (
    "start_timestamp" bigint,
    "count" bigint
);

comment on column deribit.public_get_announcements_request."start_timestamp" is 'The most recent timestamp to return the results for (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_announcements_request."count" is 'Maximum count of returned announcements';

create type deribit.public_get_announcements_response_result as (
    "body" text,
    "confirmation" boolean,
    "id" double precision,
    "important" boolean,
    "publication_timestamp" bigint,
    "title" text
);

comment on column deribit.public_get_announcements_response_result."body" is 'The HTML body of the announcement';
comment on column deribit.public_get_announcements_response_result."confirmation" is 'Whether the user confirmation is required for this announcement';
comment on column deribit.public_get_announcements_response_result."id" is 'A unique identifier for the announcement';
comment on column deribit.public_get_announcements_response_result."important" is 'Whether the announcement is marked as important';
comment on column deribit.public_get_announcements_response_result."publication_timestamp" is 'The timestamp (milliseconds since the Unix epoch) of announcement publication';
comment on column deribit.public_get_announcements_response_result."title" is 'The title of the announcement';

create type deribit.public_get_announcements_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_announcements_response_result[]
);

comment on column deribit.public_get_announcements_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_announcements_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_announcements(
    "start_timestamp" bigint default null,
    "count" bigint default null
)
returns setof deribit.public_get_announcements_response_result
language sql
as $$
    
    with request as (
        select row(
            "start_timestamp",
            "count"
        )::deribit.public_get_announcements_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_announcements'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_announcements_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."body"::text,
        (b)."confirmation"::boolean,
        (b)."id"::double precision,
        (b)."important"::boolean,
        (b)."publication_timestamp"::bigint,
        (b)."title"::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_announcements is 'Retrieves announcements. Default "start_timestamp" parameter value is current timestamp, "count" parameter value must be between 1 and 50, default is 5.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_book_summary_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_book_summary_by_currency_request_kind as enum (
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.public_get_book_summary_by_currency_request as (
    "currency" deribit.public_get_book_summary_by_currency_request_currency,
    "kind" deribit.public_get_book_summary_by_currency_request_kind
);

comment on column deribit.public_get_book_summary_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_book_summary_by_currency_request."kind" is 'Instrument kind, if not provided instruments of all kinds are considered';

create type deribit.public_get_book_summary_by_currency_response_result as (
    "ask_price" double precision,
    "base_currency" text,
    "bid_price" double precision,
    "creation_timestamp" bigint,
    "current_funding" double precision,
    "estimated_delivery_price" double precision,
    "funding_8h" double precision,
    "high" double precision,
    "instrument_name" text,
    "interest_rate" double precision,
    "last" double precision,
    "low" double precision,
    "mark_iv" double precision,
    "mark_price" double precision,
    "mid_price" double precision,
    "open_interest" double precision,
    "price_change" double precision,
    "quote_currency" text,
    "underlying_index" text,
    "underlying_price" double precision,
    "volume" double precision,
    "volume_notional" double precision,
    "volume_usd" double precision
);

comment on column deribit.public_get_book_summary_by_currency_response_result."ask_price" is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_book_summary_by_currency_response_result."base_currency" is 'Base currency';
comment on column deribit.public_get_book_summary_by_currency_response_result."bid_price" is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_book_summary_by_currency_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_book_summary_by_currency_response_result."current_funding" is 'Current funding (perpetual only)';
comment on column deribit.public_get_book_summary_by_currency_response_result."estimated_delivery_price" is 'Optional (only for derivatives). Estimated delivery price for the market. For more details, see Contract Specification > General Documentation > Expiration Price.';
comment on column deribit.public_get_book_summary_by_currency_response_result."funding_8h" is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_book_summary_by_currency_response_result."high" is 'Price of the 24h highest trade';
comment on column deribit.public_get_book_summary_by_currency_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_book_summary_by_currency_response_result."interest_rate" is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_currency_response_result."last" is 'The price of the latest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_currency_response_result."low" is 'Price of the 24h lowest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_currency_response_result."mark_iv" is '(Only for option) implied volatility for mark price';
comment on column deribit.public_get_book_summary_by_currency_response_result."mark_price" is 'The current instrument market price';
comment on column deribit.public_get_book_summary_by_currency_response_result."mid_price" is 'The average of the best bid and ask, null if there aren''t any asks or bids';
comment on column deribit.public_get_book_summary_by_currency_response_result."open_interest" is 'Optional (only for derivatives). The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_book_summary_by_currency_response_result."price_change" is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_currency_response_result."quote_currency" is 'Quote currency';
comment on column deribit.public_get_book_summary_by_currency_response_result."underlying_index" is 'Name of the underlying future, or ''index_price'' (options only)';
comment on column deribit.public_get_book_summary_by_currency_response_result."underlying_price" is 'underlying price for implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_currency_response_result."volume" is 'The total 24h traded volume (in base currency)';
comment on column deribit.public_get_book_summary_by_currency_response_result."volume_notional" is 'Volume in quote currency (futures and spots only)';
comment on column deribit.public_get_book_summary_by_currency_response_result."volume_usd" is 'Volume in USD';

create type deribit.public_get_book_summary_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_book_summary_by_currency_response_result[]
);

comment on column deribit.public_get_book_summary_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_book_summary_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_book_summary_by_currency(
    "currency" deribit.public_get_book_summary_by_currency_request_currency,
    "kind" deribit.public_get_book_summary_by_currency_request_kind default null
)
returns setof deribit.public_get_book_summary_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind"
        )::deribit.public_get_book_summary_by_currency_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_book_summary_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_book_summary_by_currency_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."ask_price"::double precision,
        (b)."base_currency"::text,
        (b)."bid_price"::double precision,
        (b)."creation_timestamp"::bigint,
        (b)."current_funding"::double precision,
        (b)."estimated_delivery_price"::double precision,
        (b)."funding_8h"::double precision,
        (b)."high"::double precision,
        (b)."instrument_name"::text,
        (b)."interest_rate"::double precision,
        (b)."last"::double precision,
        (b)."low"::double precision,
        (b)."mark_iv"::double precision,
        (b)."mark_price"::double precision,
        (b)."mid_price"::double precision,
        (b)."open_interest"::double precision,
        (b)."price_change"::double precision,
        (b)."quote_currency"::text,
        (b)."underlying_index"::text,
        (b)."underlying_price"::double precision,
        (b)."volume"::double precision,
        (b)."volume_notional"::double precision,
        (b)."volume_usd"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_book_summary_by_currency is 'Retrieves the summary information such as open interest, 24h volume, etc. for all instruments for the currency (optionally filtered by kind).';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_book_summary_by_instrument_request as (
    "instrument_name" text
);

comment on column deribit.public_get_book_summary_by_instrument_request."instrument_name" is '(Required) Instrument name';

create type deribit.public_get_book_summary_by_instrument_response_result as (
    "ask_price" double precision,
    "base_currency" text,
    "bid_price" double precision,
    "creation_timestamp" bigint,
    "current_funding" double precision,
    "estimated_delivery_price" double precision,
    "funding_8h" double precision,
    "high" double precision,
    "instrument_name" text,
    "interest_rate" double precision,
    "last" double precision,
    "low" double precision,
    "mark_iv" double precision,
    "mark_price" double precision,
    "mid_price" double precision,
    "open_interest" double precision,
    "price_change" double precision,
    "quote_currency" text,
    "underlying_index" text,
    "underlying_price" double precision,
    "volume" double precision,
    "volume_notional" double precision,
    "volume_usd" double precision
);

comment on column deribit.public_get_book_summary_by_instrument_response_result."ask_price" is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_book_summary_by_instrument_response_result."base_currency" is 'Base currency';
comment on column deribit.public_get_book_summary_by_instrument_response_result."bid_price" is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_book_summary_by_instrument_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."current_funding" is 'Current funding (perpetual only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."estimated_delivery_price" is 'Optional (only for derivatives). Estimated delivery price for the market. For more details, see Contract Specification > General Documentation > Expiration Price.';
comment on column deribit.public_get_book_summary_by_instrument_response_result."funding_8h" is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."high" is 'Price of the 24h highest trade';
comment on column deribit.public_get_book_summary_by_instrument_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_book_summary_by_instrument_response_result."interest_rate" is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."last" is 'The price of the latest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_instrument_response_result."low" is 'Price of the 24h lowest trade, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_instrument_response_result."mark_iv" is '(Only for option) implied volatility for mark price';
comment on column deribit.public_get_book_summary_by_instrument_response_result."mark_price" is 'The current instrument market price';
comment on column deribit.public_get_book_summary_by_instrument_response_result."mid_price" is 'The average of the best bid and ask, null if there aren''t any asks or bids';
comment on column deribit.public_get_book_summary_by_instrument_response_result."open_interest" is 'Optional (only for derivatives). The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_book_summary_by_instrument_response_result."price_change" is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_book_summary_by_instrument_response_result."quote_currency" is 'Quote currency';
comment on column deribit.public_get_book_summary_by_instrument_response_result."underlying_index" is 'Name of the underlying future, or ''index_price'' (options only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."underlying_price" is 'underlying price for implied volatility calculations (options only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."volume" is 'The total 24h traded volume (in base currency)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."volume_notional" is 'Volume in quote currency (futures and spots only)';
comment on column deribit.public_get_book_summary_by_instrument_response_result."volume_usd" is 'Volume in USD';

create type deribit.public_get_book_summary_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_book_summary_by_instrument_response_result[]
);

comment on column deribit.public_get_book_summary_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_book_summary_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_book_summary_by_instrument(
    "instrument_name" text
)
returns setof deribit.public_get_book_summary_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name"
        )::deribit.public_get_book_summary_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_book_summary_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_book_summary_by_instrument_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."ask_price"::double precision,
        (b)."base_currency"::text,
        (b)."bid_price"::double precision,
        (b)."creation_timestamp"::bigint,
        (b)."current_funding"::double precision,
        (b)."estimated_delivery_price"::double precision,
        (b)."funding_8h"::double precision,
        (b)."high"::double precision,
        (b)."instrument_name"::text,
        (b)."interest_rate"::double precision,
        (b)."last"::double precision,
        (b)."low"::double precision,
        (b)."mark_iv"::double precision,
        (b)."mark_price"::double precision,
        (b)."mid_price"::double precision,
        (b)."open_interest"::double precision,
        (b)."price_change"::double precision,
        (b)."quote_currency"::text,
        (b)."underlying_index"::text,
        (b)."underlying_price"::double precision,
        (b)."volume"::double precision,
        (b)."volume_notional"::double precision,
        (b)."volume_usd"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_book_summary_by_instrument is 'Retrieves the summary information such as open interest, 24h volume, etc. for a specific instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_combo_details_request as (
    "combo_id" text
);

comment on column deribit.public_get_combo_details_request."combo_id" is '(Required) Combo ID';

create type deribit.public_get_combo_details_response_leg as (
    "amount" bigint,
    "instrument_name" text
);

comment on column deribit.public_get_combo_details_response_leg."amount" is 'Size multiplier of a leg. A negative value indicates that the trades on given leg are in opposite direction to the combo trades they originate from';
comment on column deribit.public_get_combo_details_response_leg."instrument_name" is 'Unique instrument identifier';

create type deribit.public_get_combo_details_response_result as (
    "creation_timestamp" bigint,
    "id" text,
    "instrument_id" bigint,
    "legs" deribit.public_get_combo_details_response_leg[],
    "state" text,
    "state_timestamp" bigint
);

comment on column deribit.public_get_combo_details_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_combo_details_response_result."id" is 'Unique combo identifier';
comment on column deribit.public_get_combo_details_response_result."instrument_id" is 'Instrument ID';
comment on column deribit.public_get_combo_details_response_result."state" is 'Combo state: "rfq", "active", "inactive"';
comment on column deribit.public_get_combo_details_response_result."state_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.public_get_combo_details_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_combo_details_response_result
);

comment on column deribit.public_get_combo_details_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_combo_details_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_combo_details(
    "combo_id" text
)
returns deribit.public_get_combo_details_response_result
language sql
as $$
    
    with request as (
        select row(
            "combo_id"
        )::deribit.public_get_combo_details_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_combo_details'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_combo_details_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_combo_details is 'Retrieves information about a combo';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_combo_ids_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_combo_ids_request_state as enum (
    'active',
    'inactive',
    'rfq'
);

create type deribit.public_get_combo_ids_request as (
    "currency" deribit.public_get_combo_ids_request_currency,
    "state" deribit.public_get_combo_ids_request_state
);

comment on column deribit.public_get_combo_ids_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_combo_ids_request."state" is 'Combo state, if not provided combos of all states are considered';

create type deribit.public_get_combo_ids_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text[]
);

comment on column deribit.public_get_combo_ids_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_combo_ids_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_combo_ids_response."result" is 'Unique combo identifier';

create function deribit.public_get_combo_ids(
    "currency" deribit.public_get_combo_ids_request_currency,
    "state" deribit.public_get_combo_ids_request_state default null
)
returns setof text
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "state"
        )::deribit.public_get_combo_ids_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_combo_ids'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_combo_ids_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        a.b
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_combo_ids is 'Retrieves available combos. This method can be used to get the list of all combos, or only the list of combos in the given state.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_combos_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT',
    'any'
);

create type deribit.public_get_combos_request as (
    "currency" deribit.public_get_combos_request_currency
);

comment on column deribit.public_get_combos_request."currency" is '(Required) The currency symbol or "any" for all';

create type deribit.public_get_combos_response_leg as (
    "amount" bigint,
    "instrument_name" text
);

comment on column deribit.public_get_combos_response_leg."amount" is 'Size multiplier of a leg. A negative value indicates that the trades on given leg are in opposite direction to the combo trades they originate from';
comment on column deribit.public_get_combos_response_leg."instrument_name" is 'Unique instrument identifier';

create type deribit.public_get_combos_response_result as (
    "creation_timestamp" bigint,
    "id" text,
    "instrument_id" bigint,
    "legs" deribit.public_get_combos_response_leg[],
    "state" text,
    "state_timestamp" bigint
);

comment on column deribit.public_get_combos_response_result."creation_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_combos_response_result."id" is 'Unique combo identifier';
comment on column deribit.public_get_combos_response_result."instrument_id" is 'Instrument ID';
comment on column deribit.public_get_combos_response_result."state" is 'Combo state: "rfq", "active", "inactive"';
comment on column deribit.public_get_combos_response_result."state_timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.public_get_combos_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_combos_response_result[]
);

comment on column deribit.public_get_combos_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_combos_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_combos(
    "currency" deribit.public_get_combos_request_currency
)
returns setof deribit.public_get_combos_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.public_get_combos_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_combos'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_combos_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."creation_timestamp"::bigint,
        (b)."id"::text,
        (b)."instrument_id"::bigint,
        (b)."legs"::deribit.public_get_combos_response_leg[],
        (b)."state"::text,
        (b)."state_timestamp"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_combos is 'Retrieves information about active combos';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_contract_size_request as (
    "instrument_name" text
);

comment on column deribit.public_get_contract_size_request."instrument_name" is '(Required) Instrument name';

create type deribit.public_get_contract_size_response_result as (
    "contract_size" double precision
);

comment on column deribit.public_get_contract_size_response_result."contract_size" is 'Contract size, for futures in USD, for options in base currency of the instrument (BTC, ETH, ...)';

create type deribit.public_get_contract_size_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_contract_size_response_result
);

comment on column deribit.public_get_contract_size_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_contract_size_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_contract_size(
    "instrument_name" text
)
returns deribit.public_get_contract_size_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name"
        )::deribit.public_get_contract_size_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_contract_size'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_contract_size_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_contract_size is 'Retrieves contract size of provided instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_currencies_response_withdrawal_priority as (
    "name" text,
    "value" double precision
);

create type deribit.public_get_currencies_response_result as (
    "coin_type" text,
    "currency" text,
    "currency_long" text,
    "fee_precision" bigint,
    "in_cross_collateral_pool" boolean,
    "min_confirmations" bigint,
    "min_withdrawal_fee" double precision,
    "withdrawal_fee" double precision,
    "withdrawal_priorities" deribit.public_get_currencies_response_withdrawal_priority[]
);

comment on column deribit.public_get_currencies_response_result."coin_type" is 'The type of the currency.';
comment on column deribit.public_get_currencies_response_result."currency" is 'The abbreviation of the currency. This abbreviation is used elsewhere in the API to identify the currency.';
comment on column deribit.public_get_currencies_response_result."currency_long" is 'The full name for the currency.';
comment on column deribit.public_get_currencies_response_result."fee_precision" is 'fee precision';
comment on column deribit.public_get_currencies_response_result."in_cross_collateral_pool" is 'true if the currency is part of the cross collateral pool';
comment on column deribit.public_get_currencies_response_result."min_confirmations" is 'Minimum number of block chain confirmations before deposit is accepted.';
comment on column deribit.public_get_currencies_response_result."min_withdrawal_fee" is 'The minimum transaction fee paid for withdrawals';
comment on column deribit.public_get_currencies_response_result."withdrawal_fee" is 'The total transaction fee paid for withdrawals';

create type deribit.public_get_currencies_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_currencies_response_result[]
);

comment on column deribit.public_get_currencies_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_currencies_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_currencies()
returns setof deribit.public_get_currencies_response_result
language sql
as $$
    with http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_currencies'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_currencies_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."coin_type"::text,
        (b)."currency"::text,
        (b)."currency_long"::text,
        (b)."fee_precision"::bigint,
        (b)."in_cross_collateral_pool"::boolean,
        (b)."min_confirmations"::bigint,
        (b)."min_withdrawal_fee"::double precision,
        (b)."withdrawal_fee"::double precision,
        (b)."withdrawal_priorities"::deribit.public_get_currencies_response_withdrawal_priority[]
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_currencies is 'Retrieves all cryptocurrencies supported by the API.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_delivery_prices_request_index_name as enum (
    'ada_usd',
    'ada_usdc',
    'ada_usdt',
    'algo_usd',
    'algo_usdc',
    'algo_usdt',
    'avax_usd',
    'avax_usdc',
    'avax_usdt',
    'bch_usd',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usd',
    'doge_usdc',
    'doge_usdt',
    'dot_usd',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usd',
    'link_usdc',
    'link_usdt',
    'ltc_usd',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usd',
    'matic_usdc',
    'matic_usdt',
    'near_usd',
    'near_usdc',
    'near_usdt',
    'shib_usd',
    'shib_usdc',
    'shib_usdt',
    'sol_usd',
    'sol_usdc',
    'sol_usdt',
    'trx_usd',
    'trx_usdc',
    'trx_usdt',
    'uni_usd',
    'uni_usdc',
    'uni_usdt',
    'usdc_usd',
    'xrp_usd',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.public_get_delivery_prices_request as (
    "index_name" deribit.public_get_delivery_prices_request_index_name,
    "offset" bigint,
    "count" bigint
);

comment on column deribit.public_get_delivery_prices_request."index_name" is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';
comment on column deribit.public_get_delivery_prices_request."offset" is 'The offset for pagination, default - 0';
comment on column deribit.public_get_delivery_prices_request."count" is 'Number of requested items, default - 10';

create type deribit.public_get_delivery_prices_response_datum as (
    "date" text,
    "delivery_price" double precision
);

comment on column deribit.public_get_delivery_prices_response_datum."date" is 'The event date with year, month and day';
comment on column deribit.public_get_delivery_prices_response_datum."delivery_price" is 'The settlement price for the instrument. Only when state = closed';

create type deribit.public_get_delivery_prices_response_result as (
    "data" deribit.public_get_delivery_prices_response_datum[],
    "records_total" double precision
);

comment on column deribit.public_get_delivery_prices_response_result."records_total" is 'Available delivery prices';

create type deribit.public_get_delivery_prices_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_delivery_prices_response_result
);

comment on column deribit.public_get_delivery_prices_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_delivery_prices_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_delivery_prices(
    "index_name" deribit.public_get_delivery_prices_request_index_name,
    "offset" bigint default null,
    "count" bigint default null
)
returns deribit.public_get_delivery_prices_response_result
language sql
as $$
    
    with request as (
        select row(
            "index_name",
            "offset",
            "count"
        )::deribit.public_get_delivery_prices_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_delivery_prices'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_delivery_prices_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_delivery_prices is 'Retrieves delivery prices for then given index';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_funding_chart_data_request_length as enum (
    '1m',
    '24h',
    '8h'
);

create type deribit.public_get_funding_chart_data_request as (
    "instrument_name" text,
    "length" deribit.public_get_funding_chart_data_request_length
);

comment on column deribit.public_get_funding_chart_data_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_funding_chart_data_request."length" is '(Required) Specifies time period. 8h - 8 hours, 24h - 24 hours, 1m - 1 month';

create type deribit.public_get_funding_chart_data_response_datum as (
    "index_price" double precision,
    "interest_8h" double precision,
    "timestamp" bigint
);

comment on column deribit.public_get_funding_chart_data_response_datum."index_price" is 'Current index price';
comment on column deribit.public_get_funding_chart_data_response_datum."interest_8h" is 'Historical interest 8h value';
comment on column deribit.public_get_funding_chart_data_response_datum."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.public_get_funding_chart_data_response_result as (
    "current_interest" double precision,
    "data" deribit.public_get_funding_chart_data_response_datum[],
    "interest_8h" double precision
);

comment on column deribit.public_get_funding_chart_data_response_result."current_interest" is 'Current interest';
comment on column deribit.public_get_funding_chart_data_response_result."interest_8h" is 'Current interest 8h';

create type deribit.public_get_funding_chart_data_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_funding_chart_data_response_result
);

comment on column deribit.public_get_funding_chart_data_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_funding_chart_data_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_funding_chart_data(
    "instrument_name" text,
    "length" deribit.public_get_funding_chart_data_request_length
)
returns deribit.public_get_funding_chart_data_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "length"
        )::deribit.public_get_funding_chart_data_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_funding_chart_data'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_funding_chart_data_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_funding_chart_data is 'Retrieve the list of the latest PERPETUAL funding chart points within a given time period.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_funding_rate_history_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
);

comment on column deribit.public_get_funding_rate_history_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_history_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_history_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.public_get_funding_rate_history_response_result as (
    "index_price" double precision,
    "interest_1h" double precision,
    "interest_8h" double precision,
    "prev_index_price" double precision,
    "timestamp" bigint
);

comment on column deribit.public_get_funding_rate_history_response_result."index_price" is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result."interest_1h" is '1hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result."interest_8h" is '8hour interest rate';
comment on column deribit.public_get_funding_rate_history_response_result."prev_index_price" is 'Price in base currency';
comment on column deribit.public_get_funding_rate_history_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';

create type deribit.public_get_funding_rate_history_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_funding_rate_history_response_result[]
);

comment on column deribit.public_get_funding_rate_history_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_history_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_funding_rate_history(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
)
returns setof deribit.public_get_funding_rate_history_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp"
        )::deribit.public_get_funding_rate_history_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_funding_rate_history'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_funding_rate_history_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."index_price"::double precision,
        (b)."interest_1h"::double precision,
        (b)."interest_8h"::double precision,
        (b)."prev_index_price"::double precision,
        (b)."timestamp"::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_funding_rate_history is 'Retrieves hourly historical interest rate for requested PERPETUAL instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_funding_rate_value_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
);

comment on column deribit.public_get_funding_rate_value_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_funding_rate_value_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_funding_rate_value_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.public_get_funding_rate_value_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision
);

comment on column deribit.public_get_funding_rate_value_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_funding_rate_value_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_funding_rate_value(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp"
        )::deribit.public_get_funding_rate_value_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_funding_rate_value'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_funding_rate_value_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_funding_rate_value is 'Retrieves interest rate value for requested period. Applicable only for PERPETUAL instruments.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_historical_volatility_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_historical_volatility_request as (
    "currency" deribit.public_get_historical_volatility_request_currency
);

comment on column deribit.public_get_historical_volatility_request."currency" is '(Required) The currency symbol';

create type deribit.public_get_historical_volatility_response_result as (
    "timestamp" bigint,
    "value" double precision
);

create type deribit.public_get_historical_volatility_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" double precision[][]
);

comment on column deribit.public_get_historical_volatility_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_historical_volatility_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_historical_volatility(
    "currency" deribit.public_get_historical_volatility_request_currency
)
returns setof deribit.public_get_historical_volatility_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency"
        )::deribit.public_get_historical_volatility_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_historical_volatility'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_historical_volatility_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    , unnested as (
        select deribit.unnest_2d_1d(x.x)
        from result x(x)
    )
    select
        (b.x)[1]::bigint as "timestamp",
        (b.x)[2]::double precision as "value"
    from unnested b(x)
$$;

comment on function deribit.public_get_historical_volatility is 'Provides information about historical volatility for given cryptocurrency.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_index_price_request_index_name as enum (
    'ada_usd',
    'ada_usdc',
    'ada_usdt',
    'algo_usd',
    'algo_usdc',
    'algo_usdt',
    'avax_usd',
    'avax_usdc',
    'avax_usdt',
    'bch_usd',
    'bch_usdc',
    'bch_usdt',
    'bnb_usdt',
    'btc_usd',
    'btc_usdc',
    'btc_usdt',
    'btcdvol_usdc',
    'doge_usd',
    'doge_usdc',
    'doge_usdt',
    'dot_usd',
    'dot_usdc',
    'dot_usdt',
    'eth_usd',
    'eth_usdc',
    'eth_usdt',
    'ethdvol_usdc',
    'link_usd',
    'link_usdc',
    'link_usdt',
    'ltc_usd',
    'ltc_usdc',
    'ltc_usdt',
    'luna_usdt',
    'matic_usd',
    'matic_usdc',
    'matic_usdt',
    'near_usd',
    'near_usdc',
    'near_usdt',
    'shib_usd',
    'shib_usdc',
    'shib_usdt',
    'sol_usd',
    'sol_usdc',
    'sol_usdt',
    'trx_usd',
    'trx_usdc',
    'trx_usdt',
    'uni_usd',
    'uni_usdc',
    'uni_usdt',
    'usdc_usd',
    'xrp_usd',
    'xrp_usdc',
    'xrp_usdt'
);

create type deribit.public_get_index_price_request as (
    "index_name" deribit.public_get_index_price_request_index_name
);

comment on column deribit.public_get_index_price_request."index_name" is '(Required) Index identifier, matches (base) cryptocurrency with quote currency';

create type deribit.public_get_index_price_response_result as (
    "estimated_delivery_price" double precision,
    "index_price" double precision
);

comment on column deribit.public_get_index_price_response_result."estimated_delivery_price" is 'Estimated delivery price for the market. For more details, see Documentation > General > Expiration Price';
comment on column deribit.public_get_index_price_response_result."index_price" is 'Value of requested index';

create type deribit.public_get_index_price_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_index_price_response_result
);

comment on column deribit.public_get_index_price_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_index_price_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_index_price(
    "index_name" deribit.public_get_index_price_request_index_name
)
returns deribit.public_get_index_price_response_result
language sql
as $$
    
    with request as (
        select row(
            "index_name"
        )::deribit.public_get_index_price_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_index_price'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_index_price_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_index_price is 'Retrieves the current index price value for given index name.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_index_price_names_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text[]
);

comment on column deribit.public_get_index_price_names_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_index_price_names_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_index_price_names()
returns setof text
language sql
as $$
    with http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_index_price_names'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_index_price_names_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        a.b
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_index_price_names is 'Retrieves the identifiers of all supported Price Indexes';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_instrument_request as (
    "instrument_name" text
);

comment on column deribit.public_get_instrument_request."instrument_name" is '(Required) Instrument name';

create type deribit.public_get_instrument_response_tick_size_step as (
    "above_price" double precision,
    "tick_size" double precision
);

comment on column deribit.public_get_instrument_response_tick_size_step."above_price" is 'The price from which the increased tick size applies';
comment on column deribit.public_get_instrument_response_tick_size_step."tick_size" is 'Tick size to be used above the price. It must be multiple of the minimum tick size.';

create type deribit.public_get_instrument_response_result as (
    "base_currency" text,
    "block_trade_commission" double precision,
    "block_trade_min_trade_amount" double precision,
    "block_trade_tick_size" double precision,
    "contract_size" double precision,
    "counter_currency" text,
    "creation_timestamp" bigint,
    "expiration_timestamp" bigint,
    "future_type" text,
    "instrument_id" bigint,
    "instrument_name" text,
    "instrument_type" text,
    "is_active" boolean,
    "kind" text,
    "maker_commission" double precision,
    "max_leverage" bigint,
    "max_liquidation_commission" double precision,
    "min_trade_amount" double precision,
    "option_type" text,
    "price_index" text,
    "quote_currency" text,
    "rfq" boolean,
    "settlement_currency" text,
    "settlement_period" text,
    "strike" double precision,
    "taker_commission" double precision,
    "tick_size" double precision,
    "tick_size_steps" deribit.public_get_instrument_response_tick_size_step[]
);

comment on column deribit.public_get_instrument_response_result."base_currency" is 'The underlying currency being traded.';
comment on column deribit.public_get_instrument_response_result."block_trade_commission" is 'Block Trade commission for instrument.';
comment on column deribit.public_get_instrument_response_result."block_trade_min_trade_amount" is 'Minimum amount for block trading.';
comment on column deribit.public_get_instrument_response_result."block_trade_tick_size" is 'Specifies minimal price change for block trading.';
comment on column deribit.public_get_instrument_response_result."contract_size" is 'Contract size for instrument.';
comment on column deribit.public_get_instrument_response_result."counter_currency" is 'Counter currency for the instrument.';
comment on column deribit.public_get_instrument_response_result."creation_timestamp" is 'The time when the instrument was first created (milliseconds since the UNIX epoch).';
comment on column deribit.public_get_instrument_response_result."expiration_timestamp" is 'The time when the instrument will expire (milliseconds since the UNIX epoch).';
comment on column deribit.public_get_instrument_response_result."future_type" is 'Future type (only for futures)(field is deprecated and will be removed in the future, instrument_type should be used instead).';
comment on column deribit.public_get_instrument_response_result."instrument_id" is 'Instrument ID';
comment on column deribit.public_get_instrument_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_instrument_response_result."instrument_type" is 'Type of the instrument. linear or reversed';
comment on column deribit.public_get_instrument_response_result."is_active" is 'Indicates if the instrument can currently be traded.';
comment on column deribit.public_get_instrument_response_result."kind" is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.public_get_instrument_response_result."maker_commission" is 'Maker commission for instrument.';
comment on column deribit.public_get_instrument_response_result."max_leverage" is 'Maximal leverage for instrument (only for futures).';
comment on column deribit.public_get_instrument_response_result."max_liquidation_commission" is 'Maximal liquidation trade commission for instrument (only for futures).';
comment on column deribit.public_get_instrument_response_result."min_trade_amount" is 'Minimum amount for trading. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_instrument_response_result."option_type" is 'The option type (only for options).';
comment on column deribit.public_get_instrument_response_result."price_index" is 'Name of price index that is used for this instrument';
comment on column deribit.public_get_instrument_response_result."quote_currency" is 'The currency in which the instrument prices are quoted.';
comment on column deribit.public_get_instrument_response_result."rfq" is 'Whether or not RFQ is active on the instrument.';
comment on column deribit.public_get_instrument_response_result."settlement_currency" is 'Optional (not added for spot). Settlement currency for the instrument.';
comment on column deribit.public_get_instrument_response_result."settlement_period" is 'Optional (not added for spot). The settlement period.';
comment on column deribit.public_get_instrument_response_result."strike" is 'The strike value (only for options).';
comment on column deribit.public_get_instrument_response_result."taker_commission" is 'Taker commission for instrument.';
comment on column deribit.public_get_instrument_response_result."tick_size" is 'Specifies minimal price change and, as follows, the number of decimal places for instrument prices.';

create type deribit.public_get_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_instrument_response_result
);

comment on column deribit.public_get_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_instrument(
    "instrument_name" text
)
returns deribit.public_get_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name"
        )::deribit.public_get_instrument_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_instrument_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_instrument is 'Retrieves information about instrument';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_instruments_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT',
    'any'
);

create type deribit.public_get_instruments_request_kind as enum (
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.public_get_instruments_request as (
    "currency" deribit.public_get_instruments_request_currency,
    "kind" deribit.public_get_instruments_request_kind,
    "expired" boolean
);

comment on column deribit.public_get_instruments_request."currency" is '(Required) The currency symbol or "any" for all';
comment on column deribit.public_get_instruments_request."kind" is 'Instrument kind, if not provided instruments of all kinds are considered';
comment on column deribit.public_get_instruments_request."expired" is 'Set to true to show recently expired instruments instead of active ones.';

create type deribit.public_get_instruments_response_tick_size_step as (
    "above_price" double precision,
    "tick_size" double precision
);

comment on column deribit.public_get_instruments_response_tick_size_step."above_price" is 'The price from which the increased tick size applies';
comment on column deribit.public_get_instruments_response_tick_size_step."tick_size" is 'Tick size to be used above the price. It must be multiple of the minimum tick size.';

create type deribit.public_get_instruments_response_result as (
    "base_currency" text,
    "block_trade_commission" double precision,
    "block_trade_min_trade_amount" double precision,
    "block_trade_tick_size" double precision,
    "contract_size" double precision,
    "counter_currency" text,
    "creation_timestamp" bigint,
    "expiration_timestamp" bigint,
    "future_type" text,
    "instrument_id" bigint,
    "instrument_name" text,
    "instrument_type" text,
    "is_active" boolean,
    "kind" text,
    "maker_commission" double precision,
    "max_leverage" bigint,
    "max_liquidation_commission" double precision,
    "min_trade_amount" double precision,
    "option_type" text,
    "price_index" text,
    "quote_currency" text,
    "rfq" boolean,
    "settlement_currency" text,
    "settlement_period" text,
    "strike" double precision,
    "taker_commission" double precision,
    "tick_size" double precision,
    "tick_size_steps" deribit.public_get_instruments_response_tick_size_step[]
);

comment on column deribit.public_get_instruments_response_result."base_currency" is 'The underlying currency being traded.';
comment on column deribit.public_get_instruments_response_result."block_trade_commission" is 'Block Trade commission for instrument.';
comment on column deribit.public_get_instruments_response_result."block_trade_min_trade_amount" is 'Minimum amount for block trading.';
comment on column deribit.public_get_instruments_response_result."block_trade_tick_size" is 'Specifies minimal price change for block trading.';
comment on column deribit.public_get_instruments_response_result."contract_size" is 'Contract size for instrument.';
comment on column deribit.public_get_instruments_response_result."counter_currency" is 'Counter currency for the instrument.';
comment on column deribit.public_get_instruments_response_result."creation_timestamp" is 'The time when the instrument was first created (milliseconds since the UNIX epoch).';
comment on column deribit.public_get_instruments_response_result."expiration_timestamp" is 'The time when the instrument will expire (milliseconds since the UNIX epoch).';
comment on column deribit.public_get_instruments_response_result."future_type" is 'Future type (only for futures)(field is deprecated and will be removed in the future, instrument_type should be used instead).';
comment on column deribit.public_get_instruments_response_result."instrument_id" is 'Instrument ID';
comment on column deribit.public_get_instruments_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_instruments_response_result."instrument_type" is 'Type of the instrument. linear or reversed';
comment on column deribit.public_get_instruments_response_result."is_active" is 'Indicates if the instrument can currently be traded.';
comment on column deribit.public_get_instruments_response_result."kind" is 'Instrument kind: "future", "option", "spot", "future_combo", "option_combo"';
comment on column deribit.public_get_instruments_response_result."maker_commission" is 'Maker commission for instrument.';
comment on column deribit.public_get_instruments_response_result."max_leverage" is 'Maximal leverage for instrument (only for futures).';
comment on column deribit.public_get_instruments_response_result."max_liquidation_commission" is 'Maximal liquidation trade commission for instrument (only for futures).';
comment on column deribit.public_get_instruments_response_result."min_trade_amount" is 'Minimum amount for trading. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_instruments_response_result."option_type" is 'The option type (only for options).';
comment on column deribit.public_get_instruments_response_result."price_index" is 'Name of price index that is used for this instrument';
comment on column deribit.public_get_instruments_response_result."quote_currency" is 'The currency in which the instrument prices are quoted.';
comment on column deribit.public_get_instruments_response_result."rfq" is 'Whether or not RFQ is active on the instrument.';
comment on column deribit.public_get_instruments_response_result."settlement_currency" is 'Optional (not added for spot). Settlement currency for the instrument.';
comment on column deribit.public_get_instruments_response_result."settlement_period" is 'Optional (not added for spot). The settlement period.';
comment on column deribit.public_get_instruments_response_result."strike" is 'The strike value (only for options).';
comment on column deribit.public_get_instruments_response_result."taker_commission" is 'Taker commission for instrument.';
comment on column deribit.public_get_instruments_response_result."tick_size" is 'Specifies minimal price change and, as follows, the number of decimal places for instrument prices.';

create type deribit.public_get_instruments_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_instruments_response_result[]
);

comment on column deribit.public_get_instruments_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_instruments_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_instruments(
    "currency" deribit.public_get_instruments_request_currency,
    "kind" deribit.public_get_instruments_request_kind default null,
    "expired" boolean default null
)
returns setof deribit.public_get_instruments_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "expired"
        )::deribit.public_get_instruments_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_instruments'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_instruments_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."base_currency"::text,
        (b)."block_trade_commission"::double precision,
        (b)."block_trade_min_trade_amount"::double precision,
        (b)."block_trade_tick_size"::double precision,
        (b)."contract_size"::double precision,
        (b)."counter_currency"::text,
        (b)."creation_timestamp"::bigint,
        (b)."expiration_timestamp"::bigint,
        (b)."future_type"::text,
        (b)."instrument_id"::bigint,
        (b)."instrument_name"::text,
        (b)."instrument_type"::text,
        (b)."is_active"::boolean,
        (b)."kind"::text,
        (b)."maker_commission"::double precision,
        (b)."max_leverage"::bigint,
        (b)."max_liquidation_commission"::double precision,
        (b)."min_trade_amount"::double precision,
        (b)."option_type"::text,
        (b)."price_index"::text,
        (b)."quote_currency"::text,
        (b)."rfq"::boolean,
        (b)."settlement_currency"::text,
        (b)."settlement_period"::text,
        (b)."strike"::double precision,
        (b)."taker_commission"::double precision,
        (b)."tick_size"::double precision,
        (b)."tick_size_steps"::deribit.public_get_instruments_response_tick_size_step[]
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_instruments is 'Retrieves available trading instruments. This method can be used to see which instruments are available for trading, or which instruments have recently expired.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_last_settlements_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_last_settlements_by_currency_request_type as enum (
    'bankruptcy',
    'delivery',
    'settlement'
);

create type deribit.public_get_last_settlements_by_currency_request as (
    "currency" deribit.public_get_last_settlements_by_currency_request_currency,
    "type" deribit.public_get_last_settlements_by_currency_request_type,
    "count" bigint,
    "continuation" text,
    "search_start_timestamp" bigint
);

comment on column deribit.public_get_last_settlements_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_last_settlements_by_currency_request."type" is 'Settlement type';
comment on column deribit.public_get_last_settlements_by_currency_request."count" is 'Number of requested items, default - 20';
comment on column deribit.public_get_last_settlements_by_currency_request."continuation" is 'Continuation token for pagination';
comment on column deribit.public_get_last_settlements_by_currency_request."search_start_timestamp" is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.public_get_last_settlements_by_currency_response_settlement as (
    "funded" double precision,
    "funding" double precision,
    "index_price" double precision,
    "instrument_name" text,
    "mark_price" double precision,
    "position" double precision,
    "profit_loss" double precision,
    "session_bankruptcy" double precision,
    "session_profit_loss" double precision,
    "session_tax" double precision,
    "session_tax_rate" double precision,
    "socialized" double precision,
    "timestamp" bigint,
    "type" text
);

comment on column deribit.public_get_last_settlements_by_currency_response_settlement."funded" is 'funded amount (bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."funding" is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."index_price" is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."instrument_name" is 'instrument name (settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."mark_price" is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."position" is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."profit_loss" is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."session_bankruptcy" is 'value of session bankruptcy (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."session_profit_loss" is 'total value of session profit and losses (in base currency)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."session_tax" is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."session_tax_rate" is 'rate of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."socialized" is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_last_settlements_by_currency_response_settlement."type" is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.public_get_last_settlements_by_currency_response_result as (
    "continuation" text,
    "settlements" deribit.public_get_last_settlements_by_currency_response_settlement[]
);

comment on column deribit.public_get_last_settlements_by_currency_response_result."continuation" is 'Continuation token for pagination.';

create type deribit.public_get_last_settlements_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_last_settlements_by_currency_response_result
);

comment on column deribit.public_get_last_settlements_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_last_settlements_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_last_settlements_by_currency(
    "currency" deribit.public_get_last_settlements_by_currency_request_currency,
    "type" deribit.public_get_last_settlements_by_currency_request_type default null,
    "count" bigint default null,
    "continuation" text default null,
    "search_start_timestamp" bigint default null
)
returns deribit.public_get_last_settlements_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "type",
            "count",
            "continuation",
            "search_start_timestamp"
        )::deribit.public_get_last_settlements_by_currency_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_last_settlements_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_last_settlements_by_currency_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_last_settlements_by_currency is 'Retrieves historical settlement, delivery and bankruptcy events coming from all instruments within a given currency.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_last_settlements_by_instrument_request_type as enum (
    'bankruptcy',
    'delivery',
    'settlement'
);

create type deribit.public_get_last_settlements_by_instrument_request as (
    "instrument_name" text,
    "type" deribit.public_get_last_settlements_by_instrument_request_type,
    "count" bigint,
    "continuation" text,
    "search_start_timestamp" bigint
);

comment on column deribit.public_get_last_settlements_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_last_settlements_by_instrument_request."type" is 'Settlement type';
comment on column deribit.public_get_last_settlements_by_instrument_request."count" is 'Number of requested items, default - 20';
comment on column deribit.public_get_last_settlements_by_instrument_request."continuation" is 'Continuation token for pagination';
comment on column deribit.public_get_last_settlements_by_instrument_request."search_start_timestamp" is 'The latest timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.public_get_last_settlements_by_instrument_response_settlement as (
    "funded" double precision,
    "funding" double precision,
    "index_price" double precision,
    "instrument_name" text,
    "mark_price" double precision,
    "position" double precision,
    "profit_loss" double precision,
    "session_bankruptcy" double precision,
    "session_profit_loss" double precision,
    "session_tax" double precision,
    "session_tax_rate" double precision,
    "socialized" double precision,
    "timestamp" bigint,
    "type" text
);

comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."funded" is 'funded amount (bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."funding" is 'funding (in base currency ; settlement for perpetual product only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."index_price" is 'underlying index price at time of event (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."instrument_name" is 'instrument name (settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."mark_price" is 'mark price for at the settlement time (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."position" is 'position size (in quote currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."profit_loss" is 'profit and loss (in base currency; settlement and delivery only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."session_bankruptcy" is 'value of session bankruptcy (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."session_profit_loss" is 'total value of session profit and losses (in base currency)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."session_tax" is 'total amount of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."session_tax_rate" is 'rate of paid taxes/fees (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."socialized" is 'the amount of the socialized losses (in base currency; bankruptcy only)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_last_settlements_by_instrument_response_settlement."type" is 'The type of settlement. settlement, delivery or bankruptcy.';

create type deribit.public_get_last_settlements_by_instrument_response_result as (
    "continuation" text,
    "settlements" deribit.public_get_last_settlements_by_instrument_response_settlement[]
);

comment on column deribit.public_get_last_settlements_by_instrument_response_result."continuation" is 'Continuation token for pagination.';

create type deribit.public_get_last_settlements_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_last_settlements_by_instrument_response_result
);

comment on column deribit.public_get_last_settlements_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_last_settlements_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_last_settlements_by_instrument(
    "instrument_name" text,
    "type" deribit.public_get_last_settlements_by_instrument_request_type default null,
    "count" bigint default null,
    "continuation" text default null,
    "search_start_timestamp" bigint default null
)
returns deribit.public_get_last_settlements_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "type",
            "count",
            "continuation",
            "search_start_timestamp"
        )::deribit.public_get_last_settlements_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_last_settlements_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_last_settlements_by_instrument_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_last_settlements_by_instrument is 'Retrieves historical public settlement, delivery and bankruptcy events filtered by instrument name.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_last_trades_by_currency_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_last_trades_by_currency_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.public_get_last_trades_by_currency_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.public_get_last_trades_by_currency_request as (
    "currency" deribit.public_get_last_trades_by_currency_request_currency,
    "kind" deribit.public_get_last_trades_by_currency_request_kind,
    "start_id" text,
    "end_id" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint,
    "sorting" deribit.public_get_last_trades_by_currency_request_sorting
);

comment on column deribit.public_get_last_trades_by_currency_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_last_trades_by_currency_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.public_get_last_trades_by_currency_request."start_id" is 'The ID of the first trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.public_get_last_trades_by_currency_request."end_id" is 'The ID of the last trade to be returned. Number for BTC trades, or hyphen name in ex. "ETH-15" # "ETH_USDC-16"';
comment on column deribit.public_get_last_trades_by_currency_request."start_timestamp" is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.public_get_last_trades_by_currency_request."end_timestamp" is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.public_get_last_trades_by_currency_request."count" is 'Number of requested items, default - 10';
comment on column deribit.public_get_last_trades_by_currency_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.public_get_last_trades_by_currency_response_trade as (
    "amount" double precision,
    "block_trade_id" text,
    "block_trade_leg_count" bigint,
    "contracts" double precision,
    "direction" text,
    "index_price" double precision,
    "instrument_name" text,
    "iv" double precision,
    "liquidation" text,
    "mark_price" double precision,
    "price" double precision,
    "tick_direction" bigint,
    "timestamp" bigint,
    "trade_id" text,
    "trade_seq" bigint
);

comment on column deribit.public_get_last_trades_by_currency_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_last_trades_by_currency_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_currency_response_trade."block_trade_leg_count" is 'Block trade leg count - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_currency_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.public_get_last_trades_by_currency_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.public_get_last_trades_by_currency_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_currency_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_last_trades_by_currency_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.public_get_last_trades_by_currency_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.public_get_last_trades_by_currency_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_currency_response_trade."price" is 'Price in base currency';
comment on column deribit.public_get_last_trades_by_currency_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.public_get_last_trades_by_currency_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_last_trades_by_currency_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.public_get_last_trades_by_currency_response_trade."trade_seq" is 'The sequence number of the trade within instrument';

create type deribit.public_get_last_trades_by_currency_response_result as (
    "has_more" boolean,
    "trades" deribit.public_get_last_trades_by_currency_response_trade[]
);

create type deribit.public_get_last_trades_by_currency_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_last_trades_by_currency_response_result
);

comment on column deribit.public_get_last_trades_by_currency_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_last_trades_by_currency_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_last_trades_by_currency(
    "currency" deribit.public_get_last_trades_by_currency_request_currency,
    "kind" deribit.public_get_last_trades_by_currency_request_kind default null,
    "start_id" text default null,
    "end_id" text default null,
    "start_timestamp" bigint default null,
    "end_timestamp" bigint default null,
    "count" bigint default null,
    "sorting" deribit.public_get_last_trades_by_currency_request_sorting default null
)
returns deribit.public_get_last_trades_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "start_id",
            "end_id",
            "start_timestamp",
            "end_timestamp",
            "count",
            "sorting"
        )::deribit.public_get_last_trades_by_currency_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_last_trades_by_currency'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_last_trades_by_currency_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_last_trades_by_currency is 'Retrieve the latest trades that have occurred for instruments in a specific currency symbol.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_last_trades_by_currency_and_time_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_last_trades_by_currency_and_time_request_kind as enum (
    'any',
    'combo',
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.public_get_last_trades_by_currency_and_time_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.public_get_last_trades_by_currency_and_time_request as (
    "currency" deribit.public_get_last_trades_by_currency_and_time_request_currency,
    "kind" deribit.public_get_last_trades_by_currency_and_time_request_kind,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint,
    "sorting" deribit.public_get_last_trades_by_currency_and_time_request_sorting
);

comment on column deribit.public_get_last_trades_by_currency_and_time_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_last_trades_by_currency_and_time_request."kind" is 'Instrument kind, "combo" for any combo or "any" for all. If not provided instruments of all kinds are considered';
comment on column deribit.public_get_last_trades_by_currency_and_time_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.public_get_last_trades_by_currency_and_time_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.public_get_last_trades_by_currency_and_time_request."count" is 'Number of requested items, default - 10';
comment on column deribit.public_get_last_trades_by_currency_and_time_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.public_get_last_trades_by_currency_and_time_response_trade as (
    "amount" double precision,
    "block_trade_id" text,
    "block_trade_leg_count" bigint,
    "contracts" double precision,
    "direction" text,
    "index_price" double precision,
    "instrument_name" text,
    "iv" double precision,
    "liquidation" text,
    "mark_price" double precision,
    "price" double precision,
    "tick_direction" bigint,
    "timestamp" bigint,
    "trade_id" text,
    "trade_seq" bigint
);

comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."block_trade_leg_count" is 'Block trade leg count - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."price" is 'Price in base currency';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.public_get_last_trades_by_currency_and_time_response_trade."trade_seq" is 'The sequence number of the trade within instrument';

create type deribit.public_get_last_trades_by_currency_and_time_response_result as (
    "has_more" boolean,
    "trades" deribit.public_get_last_trades_by_currency_and_time_response_trade[]
);

create type deribit.public_get_last_trades_by_currency_and_time_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_last_trades_by_currency_and_time_response_result
);

comment on column deribit.public_get_last_trades_by_currency_and_time_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_last_trades_by_currency_and_time_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_last_trades_by_currency_and_time(
    "currency" deribit.public_get_last_trades_by_currency_and_time_request_currency,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "kind" deribit.public_get_last_trades_by_currency_and_time_request_kind default null,
    "count" bigint default null,
    "sorting" deribit.public_get_last_trades_by_currency_and_time_request_sorting default null
)
returns deribit.public_get_last_trades_by_currency_and_time_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind",
            "start_timestamp",
            "end_timestamp",
            "count",
            "sorting"
        )::deribit.public_get_last_trades_by_currency_and_time_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_last_trades_by_currency_and_time'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_last_trades_by_currency_and_time_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_last_trades_by_currency_and_time is 'Retrieve the latest trades that have occurred for instruments in a specific currency symbol and within a given time range.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_last_trades_by_instrument_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.public_get_last_trades_by_instrument_request as (
    "instrument_name" text,
    "start_seq" bigint,
    "end_seq" bigint,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint,
    "sorting" deribit.public_get_last_trades_by_instrument_request_sorting
);

comment on column deribit.public_get_last_trades_by_instrument_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_last_trades_by_instrument_request."start_seq" is 'The sequence number of the first trade to be returned';
comment on column deribit.public_get_last_trades_by_instrument_request."end_seq" is 'The sequence number of the last trade to be returned';
comment on column deribit.public_get_last_trades_by_instrument_request."start_timestamp" is 'The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.public_get_last_trades_by_instrument_request."end_timestamp" is 'The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.public_get_last_trades_by_instrument_request."count" is 'Number of requested items, default - 10';
comment on column deribit.public_get_last_trades_by_instrument_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.public_get_last_trades_by_instrument_response_trade as (
    "amount" double precision,
    "block_trade_id" text,
    "block_trade_leg_count" bigint,
    "contracts" double precision,
    "direction" text,
    "index_price" double precision,
    "instrument_name" text,
    "iv" double precision,
    "liquidation" text,
    "mark_price" double precision,
    "price" double precision,
    "tick_direction" bigint,
    "timestamp" bigint,
    "trade_id" text,
    "trade_seq" bigint
);

comment on column deribit.public_get_last_trades_by_instrument_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."block_trade_leg_count" is 'Block trade leg count - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."price" is 'Price in base currency';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.public_get_last_trades_by_instrument_response_trade."trade_seq" is 'The sequence number of the trade within instrument';

create type deribit.public_get_last_trades_by_instrument_response_result as (
    "has_more" boolean,
    "trades" deribit.public_get_last_trades_by_instrument_response_trade[]
);

create type deribit.public_get_last_trades_by_instrument_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_last_trades_by_instrument_response_result
);

comment on column deribit.public_get_last_trades_by_instrument_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_last_trades_by_instrument_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_last_trades_by_instrument(
    "instrument_name" text,
    "start_seq" bigint default null,
    "end_seq" bigint default null,
    "start_timestamp" bigint default null,
    "end_timestamp" bigint default null,
    "count" bigint default null,
    "sorting" deribit.public_get_last_trades_by_instrument_request_sorting default null
)
returns deribit.public_get_last_trades_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_seq",
            "end_seq",
            "start_timestamp",
            "end_timestamp",
            "count",
            "sorting"
        )::deribit.public_get_last_trades_by_instrument_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_last_trades_by_instrument'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_last_trades_by_instrument_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_last_trades_by_instrument is 'Retrieve the latest trades that have occurred for a specific instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_last_trades_by_instrument_and_time_request_sorting as enum (
    'asc',
    'default',
    'desc'
);

create type deribit.public_get_last_trades_by_instrument_and_time_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint,
    "sorting" deribit.public_get_last_trades_by_instrument_and_time_request_sorting
);

comment on column deribit.public_get_last_trades_by_instrument_and_time_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_last_trades_by_instrument_and_time_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch). When param is provided trades are returned from the earliest';
comment on column deribit.public_get_last_trades_by_instrument_and_time_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch). Only one of params: start_timestamp, end_timestamp is truly required';
comment on column deribit.public_get_last_trades_by_instrument_and_time_request."count" is 'Number of requested items, default - 10';
comment on column deribit.public_get_last_trades_by_instrument_and_time_request."sorting" is 'Direction of results sorting (default value means no sorting, results will be returned in order in which they left the database)';

create type deribit.public_get_last_trades_by_instrument_and_time_response_trade as (
    "amount" double precision,
    "block_trade_id" text,
    "block_trade_leg_count" bigint,
    "contracts" double precision,
    "direction" text,
    "index_price" double precision,
    "instrument_name" text,
    "iv" double precision,
    "liquidation" text,
    "mark_price" double precision,
    "price" double precision,
    "tick_direction" bigint,
    "timestamp" bigint,
    "trade_id" text,
    "trade_seq" bigint
);

comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."amount" is 'Trade amount. For perpetual and futures - in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."block_trade_id" is 'Block trade id - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."block_trade_leg_count" is 'Block trade leg count - when trade was part of a block trade';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."contracts" is 'Trade size in contract units (optional, may be absent in historical trades)';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."direction" is 'Direction: buy, or sell';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."index_price" is 'Index Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."iv" is 'Option implied volatility for the price (Option only)';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."liquidation" is 'Optional field (only for trades caused by liquidation): "M" when maker side of trade was under liquidation, "T" when taker side was under liquidation, "MT" when both sides of trade were under liquidation';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."mark_price" is 'Mark Price at the moment of trade';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."price" is 'Price in base currency';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."tick_direction" is 'Direction of the "tick" (0 = Plus Tick, 1 = Zero-Plus Tick, 2 = Minus Tick, 3 = Zero-Minus Tick).';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."timestamp" is 'The timestamp of the trade (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."trade_id" is 'Unique (per currency) trade identifier';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response_trade."trade_seq" is 'The sequence number of the trade within instrument';

create type deribit.public_get_last_trades_by_instrument_and_time_response_result as (
    "has_more" boolean,
    "trades" deribit.public_get_last_trades_by_instrument_and_time_response_trade[]
);

create type deribit.public_get_last_trades_by_instrument_and_time_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_last_trades_by_instrument_and_time_response_result
);

comment on column deribit.public_get_last_trades_by_instrument_and_time_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_last_trades_by_instrument_and_time_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_last_trades_by_instrument_and_time(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "count" bigint default null,
    "sorting" deribit.public_get_last_trades_by_instrument_and_time_request_sorting default null
)
returns deribit.public_get_last_trades_by_instrument_and_time_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp",
            "count",
            "sorting"
        )::deribit.public_get_last_trades_by_instrument_and_time_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_last_trades_by_instrument_and_time'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_last_trades_by_instrument_and_time_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_last_trades_by_instrument_and_time is 'Retrieve the latest trades that have occurred for a specific instrument and within a given time range.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_mark_price_history_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
);

comment on column deribit.public_get_mark_price_history_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_mark_price_history_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_mark_price_history_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';

create type deribit.public_get_mark_price_history_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text[]
);

comment on column deribit.public_get_mark_price_history_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_mark_price_history_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_mark_price_history_response."result" is 'Markprice history values as an array of arrays with 2 values each. The inner values correspond to the timestamp in ms and the markprice itself.';

create function deribit.public_get_mark_price_history(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint
)
returns setof text
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp"
        )::deribit.public_get_mark_price_history_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_mark_price_history'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_mark_price_history_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        a.b
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_mark_price_history is 'Public request for 5min history of markprice values for the instrument. For now the markprice history is available only for a subset of options which take part in the volatility index calculations. All other instruments, futures and perpetuals will return an empty list.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_order_book_request_depth as enum (
    '1',
    '10',
    '100',
    '1000',
    '10000',
    '20',
    '5',
    '50'
);

create type deribit.public_get_order_book_request as (
    "instrument_name" text,
    "depth" deribit.public_get_order_book_request_depth
);

comment on column deribit.public_get_order_book_request."instrument_name" is '(Required) The instrument name for which to retrieve the order book, see public/get_instruments to obtain instrument names.';
comment on column deribit.public_get_order_book_request."depth" is 'The number of entries to return for bids and asks.';

create type deribit.public_get_order_book_response_stats as (
    "high" double precision,
    "low" double precision,
    "price_change" double precision,
    "volume" double precision,
    "volume_usd" double precision
);

comment on column deribit.public_get_order_book_response_stats."high" is 'Highest price during 24h';
comment on column deribit.public_get_order_book_response_stats."low" is 'Lowest price during 24h';
comment on column deribit.public_get_order_book_response_stats."price_change" is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_order_book_response_stats."volume" is 'Volume during last 24h in base currency';
comment on column deribit.public_get_order_book_response_stats."volume_usd" is 'Volume in usd (futures only)';

create type deribit.public_get_order_book_response_greeks as (
    "delta" double precision,
    "gamma" double precision,
    "rho" double precision,
    "theta" double precision,
    "vega" double precision
);

comment on column deribit.public_get_order_book_response_greeks."delta" is '(Only for option) The delta value for the option';
comment on column deribit.public_get_order_book_response_greeks."gamma" is '(Only for option) The gamma value for the option';
comment on column deribit.public_get_order_book_response_greeks."rho" is '(Only for option) The rho value for the option';
comment on column deribit.public_get_order_book_response_greeks."theta" is '(Only for option) The theta value for the option';
comment on column deribit.public_get_order_book_response_greeks."vega" is '(Only for option) The vega value for the option';

create type deribit.public_get_order_book_response_result as (
    "ask_iv" double precision,
    "asks" double precision[][],
    "best_ask_amount" double precision,
    "best_ask_price" double precision,
    "best_bid_amount" double precision,
    "best_bid_price" double precision,
    "bid_iv" double precision,
    "bids" double precision[][],
    "current_funding" double precision,
    "delivery_price" double precision,
    "funding_8h" double precision,
    "greeks" deribit.public_get_order_book_response_greeks,
    "index_price" double precision,
    "instrument_name" text,
    "interest_rate" double precision,
    "last_price" double precision,
    "mark_iv" double precision,
    "mark_price" double precision,
    "max_price" double precision,
    "min_price" double precision,
    "open_interest" double precision,
    "settlement_price" double precision,
    "state" text,
    "stats" deribit.public_get_order_book_response_stats,
    "timestamp" bigint,
    "underlying_index" text,
    "underlying_price" double precision
);

comment on column deribit.public_get_order_book_response_result."ask_iv" is '(Only for option) implied volatility for best ask';
comment on column deribit.public_get_order_book_response_result."asks" is 'List of asks';
comment on column deribit.public_get_order_book_response_result."best_ask_amount" is 'It represents the requested order size of all best asks';
comment on column deribit.public_get_order_book_response_result."best_ask_price" is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_order_book_response_result."best_bid_amount" is 'It represents the requested order size of all best bids';
comment on column deribit.public_get_order_book_response_result."best_bid_price" is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_order_book_response_result."bid_iv" is '(Only for option) implied volatility for best bid';
comment on column deribit.public_get_order_book_response_result."bids" is 'List of bids';
comment on column deribit.public_get_order_book_response_result."current_funding" is 'Current funding (perpetual only)';
comment on column deribit.public_get_order_book_response_result."delivery_price" is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_get_order_book_response_result."funding_8h" is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_order_book_response_result."greeks" is 'Only for options';
comment on column deribit.public_get_order_book_response_result."index_price" is 'Current index price';
comment on column deribit.public_get_order_book_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_order_book_response_result."interest_rate" is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_order_book_response_result."last_price" is 'The price for the last trade';
comment on column deribit.public_get_order_book_response_result."mark_iv" is '(Only for option) implied volatility for mark price';
comment on column deribit.public_get_order_book_response_result."mark_price" is 'The mark price for the instrument';
comment on column deribit.public_get_order_book_response_result."max_price" is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.public_get_order_book_response_result."min_price" is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.public_get_order_book_response_result."open_interest" is 'The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_order_book_response_result."settlement_price" is 'Optional (not added for spot). The settlement price for the instrument. Only when state = open';
comment on column deribit.public_get_order_book_response_result."state" is 'The state of the order book. Possible values are open and closed.';
comment on column deribit.public_get_order_book_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_order_book_response_result."underlying_index" is 'Name of the underlying future, or index_price (options only)';
comment on column deribit.public_get_order_book_response_result."underlying_price" is 'Underlying price for implied volatility calculations (options only)';

create type deribit.public_get_order_book_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_order_book_response_result
);

comment on column deribit.public_get_order_book_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_order_book_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_order_book(
    "instrument_name" text,
    "depth" deribit.public_get_order_book_request_depth default null
)
returns deribit.public_get_order_book_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "depth"
        )::deribit.public_get_order_book_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_order_book'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_order_book_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_order_book is 'Retrieves the order book, along with other market values for a given instrument.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_order_book_by_instrument_id_request_depth as enum (
    '1',
    '10',
    '100',
    '1000',
    '10000',
    '20',
    '5',
    '50'
);

create type deribit.public_get_order_book_by_instrument_id_request as (
    "instrument_id" bigint,
    "depth" deribit.public_get_order_book_by_instrument_id_request_depth
);

comment on column deribit.public_get_order_book_by_instrument_id_request."instrument_id" is '(Required) The instrument ID for which to retrieve the order book, see public/get_instruments to obtain instrument IDs.';
comment on column deribit.public_get_order_book_by_instrument_id_request."depth" is 'The number of entries to return for bids and asks.';

create type deribit.public_get_order_book_by_instrument_id_response_stats as (
    "high" double precision,
    "low" double precision,
    "price_change" double precision,
    "volume" double precision,
    "volume_usd" double precision
);

comment on column deribit.public_get_order_book_by_instrument_id_response_stats."high" is 'Highest price during 24h';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats."low" is 'Lowest price during 24h';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats."price_change" is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats."volume" is 'Volume during last 24h in base currency';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats."volume_usd" is 'Volume in usd (futures only)';

create type deribit.public_get_order_book_by_instrument_id_response_greeks as (
    "delta" double precision,
    "gamma" double precision,
    "rho" double precision,
    "theta" double precision,
    "vega" double precision
);

comment on column deribit.public_get_order_book_by_instrument_id_response_greeks."delta" is '(Only for option) The delta value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks."gamma" is '(Only for option) The gamma value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks."rho" is '(Only for option) The rho value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks."theta" is '(Only for option) The theta value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks."vega" is '(Only for option) The vega value for the option';

create type deribit.public_get_order_book_by_instrument_id_response_result as (
    "ask_iv" double precision,
    "asks" double precision[][],
    "best_ask_amount" double precision,
    "best_ask_price" double precision,
    "best_bid_amount" double precision,
    "best_bid_price" double precision,
    "bid_iv" double precision,
    "bids" double precision[][],
    "current_funding" double precision,
    "delivery_price" double precision,
    "funding_8h" double precision,
    "greeks" deribit.public_get_order_book_by_instrument_id_response_greeks,
    "index_price" double precision,
    "instrument_name" text,
    "interest_rate" double precision,
    "last_price" double precision,
    "mark_iv" double precision,
    "mark_price" double precision,
    "max_price" double precision,
    "min_price" double precision,
    "open_interest" double precision,
    "settlement_price" double precision,
    "state" text,
    "stats" deribit.public_get_order_book_by_instrument_id_response_stats,
    "timestamp" bigint,
    "underlying_index" text,
    "underlying_price" double precision
);

comment on column deribit.public_get_order_book_by_instrument_id_response_result."ask_iv" is '(Only for option) implied volatility for best ask';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."asks" is 'List of asks';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."best_ask_amount" is 'It represents the requested order size of all best asks';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."best_ask_price" is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."best_bid_amount" is 'It represents the requested order size of all best bids';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."best_bid_price" is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."bid_iv" is '(Only for option) implied volatility for best bid';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."bids" is 'List of bids';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."current_funding" is 'Current funding (perpetual only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."delivery_price" is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."funding_8h" is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."greeks" is 'Only for options';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."index_price" is 'Current index price';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."interest_rate" is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."last_price" is 'The price for the last trade';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."mark_iv" is '(Only for option) implied volatility for mark price';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."mark_price" is 'The mark price for the instrument';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."max_price" is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."min_price" is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."open_interest" is 'The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."settlement_price" is 'Optional (not added for spot). The settlement price for the instrument. Only when state = open';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."state" is 'The state of the order book. Possible values are open and closed.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."underlying_index" is 'Name of the underlying future, or index_price (options only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result."underlying_price" is 'Underlying price for implied volatility calculations (options only)';

create type deribit.public_get_order_book_by_instrument_id_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_order_book_by_instrument_id_response_result
);

comment on column deribit.public_get_order_book_by_instrument_id_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_order_book_by_instrument_id_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_order_book_by_instrument_id(
    "instrument_id" bigint,
    "depth" deribit.public_get_order_book_by_instrument_id_request_depth default null
)
returns deribit.public_get_order_book_by_instrument_id_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_id",
            "depth"
        )::deribit.public_get_order_book_by_instrument_id_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_order_book_by_instrument_id'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_order_book_by_instrument_id_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_order_book_by_instrument_id is 'Retrieves the order book, along with other market values for a given instrument ID.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_rfqs_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_rfqs_request_kind as enum (
    'future',
    'future_combo',
    'option',
    'option_combo',
    'spot'
);

create type deribit.public_get_rfqs_request as (
    "currency" deribit.public_get_rfqs_request_currency,
    "kind" deribit.public_get_rfqs_request_kind
);

comment on column deribit.public_get_rfqs_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_rfqs_request."kind" is 'Instrument kind, if not provided instruments of all kinds are considered';

create type deribit.public_get_rfqs_response_result as (
    "amount" double precision,
    "instrument_name" text,
    "last_rfq_timestamp" bigint,
    "side" text,
    "traded_volume" double precision
);

comment on column deribit.public_get_rfqs_response_result."amount" is 'It represents the requested order size. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_rfqs_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_get_rfqs_response_result."last_rfq_timestamp" is 'The timestamp of last RFQ (milliseconds since the Unix epoch)';
comment on column deribit.public_get_rfqs_response_result."side" is 'Side - buy or sell';
comment on column deribit.public_get_rfqs_response_result."traded_volume" is 'Volume traded since last RFQ';

create type deribit.public_get_rfqs_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_rfqs_response_result[]
);

comment on column deribit.public_get_rfqs_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_rfqs_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_rfqs(
    "currency" deribit.public_get_rfqs_request_currency,
    "kind" deribit.public_get_rfqs_request_kind default null
)
returns setof deribit.public_get_rfqs_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "kind"
        )::deribit.public_get_rfqs_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_rfqs'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_rfqs_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."amount"::double precision,
        (b)."instrument_name"::text,
        (b)."last_rfq_timestamp"::bigint,
        (b)."side"::text,
        (b)."traded_volume"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_rfqs is 'Retrieve active RFQs for instruments in given currency.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_supported_index_names_request_type as enum (
    'all',
    'derivative',
    'spot'
);

create type deribit.public_get_supported_index_names_request as (
    "type" deribit.public_get_supported_index_names_request_type
);

comment on column deribit.public_get_supported_index_names_request."type" is 'Type of a cryptocurrency price index';

create type deribit.public_get_supported_index_names_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text[]
);

comment on column deribit.public_get_supported_index_names_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_supported_index_names_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_supported_index_names(
    "type" deribit.public_get_supported_index_names_request_type default null
)
returns setof text
language sql
as $$
    
    with request as (
        select row(
            "type"
        )::deribit.public_get_supported_index_names_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_supported_index_names'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_supported_index_names_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        a.b
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_supported_index_names is 'Retrieves the identifiers of all supported Price Indexes';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_time_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" bigint
);

comment on column deribit.public_get_time_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_time_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_time_response."result" is 'Current timestamp (milliseconds since the UNIX epoch)';

create function deribit.public_get_time()
returns bigint
language sql
as $$
    with http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_time'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_time_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_time is 'Retrieves the current time (in milliseconds). This API endpoint can be used to check the clock skew between your software and Deribit''s systems.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_trade_volumes_request as (
    "extended" boolean
);

comment on column deribit.public_get_trade_volumes_request."extended" is 'Request for extended statistics. Including also 7 and 30 days volumes (default false)';

create type deribit.public_get_trade_volumes_response_result as (
    "calls_volume" double precision,
    "calls_volume_30d" double precision,
    "calls_volume_7d" double precision,
    "currency" text,
    "futures_volume" double precision,
    "futures_volume_30d" double precision,
    "futures_volume_7d" double precision,
    "puts_volume" double precision,
    "puts_volume_30d" double precision,
    "puts_volume_7d" double precision,
    "spot_volume" double precision,
    "spot_volume_30d" double precision,
    "spot_volume_7d" double precision
);

comment on column deribit.public_get_trade_volumes_response_result."calls_volume" is 'Total 24h trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result."calls_volume_30d" is 'Total 30d trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result."calls_volume_7d" is 'Total 7d trade volume for call options.';
comment on column deribit.public_get_trade_volumes_response_result."currency" is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.public_get_trade_volumes_response_result."futures_volume" is 'Total 24h trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result."futures_volume_30d" is 'Total 30d trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result."futures_volume_7d" is 'Total 7d trade volume for futures.';
comment on column deribit.public_get_trade_volumes_response_result."puts_volume" is 'Total 24h trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result."puts_volume_30d" is 'Total 30d trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result."puts_volume_7d" is 'Total 7d trade volume for put options.';
comment on column deribit.public_get_trade_volumes_response_result."spot_volume" is 'Total 24h trade for spot.';
comment on column deribit.public_get_trade_volumes_response_result."spot_volume_30d" is 'Total 30d trade for spot.';
comment on column deribit.public_get_trade_volumes_response_result."spot_volume_7d" is 'Total 7d trade for spot.';

create type deribit.public_get_trade_volumes_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_trade_volumes_response_result[]
);

comment on column deribit.public_get_trade_volumes_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_trade_volumes_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_trade_volumes(
    "extended" boolean default null
)
returns setof deribit.public_get_trade_volumes_response_result
language sql
as $$
    
    with request as (
        select row(
            "extended"
        )::deribit.public_get_trade_volumes_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_trade_volumes'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    ),
    result as (
        select (jsonb_populate_record(
            null::deribit.public_get_trade_volumes_response,
            convert_from((http_response.http_response).body, 'utf-8')::jsonb)
        ).result
        from http_response
    )
    select
        (b)."calls_volume"::double precision,
        (b)."calls_volume_30d"::double precision,
        (b)."calls_volume_7d"::double precision,
        (b)."currency"::text,
        (b)."futures_volume"::double precision,
        (b)."futures_volume_30d"::double precision,
        (b)."futures_volume_7d"::double precision,
        (b)."puts_volume"::double precision,
        (b)."puts_volume_30d"::double precision,
        (b)."puts_volume_7d"::double precision,
        (b)."spot_volume"::double precision,
        (b)."spot_volume_30d"::double precision,
        (b)."spot_volume_7d"::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_trade_volumes is 'Retrieves aggregated 24h trade volumes for different instrument types and currencies.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_tradingview_chart_data_request_resolution as enum (
    '1',
    '10',
    '120',
    '15',
    '180',
    '1D',
    '3',
    '30',
    '360',
    '5',
    '60',
    '720'
);

create type deribit.public_get_tradingview_chart_data_request as (
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "resolution" deribit.public_get_tradingview_chart_data_request_resolution
);

comment on column deribit.public_get_tradingview_chart_data_request."instrument_name" is '(Required) Instrument name';
comment on column deribit.public_get_tradingview_chart_data_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_tradingview_chart_data_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_tradingview_chart_data_request."resolution" is '(Required) Chart bars resolution given in full minutes or keyword 1D (only some specific resolutions are supported)';

create type deribit.public_get_tradingview_chart_data_response_result as (
    "close" double precision[],
    "cost" double precision[],
    "high" double precision[],
    "low" double precision[],
    "open" double precision[],
    "status" text,
    "ticks" bigint[],
    "volume" double precision[]
);

comment on column deribit.public_get_tradingview_chart_data_response_result."close" is 'List of prices at close (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result."cost" is 'List of cost bars (volume in quote currency, one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result."high" is 'List of highest price levels (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result."low" is 'List of lowest price levels (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result."open" is 'List of prices at open (one per candle)';
comment on column deribit.public_get_tradingview_chart_data_response_result."status" is 'Status of the query: ok or no_data';
comment on column deribit.public_get_tradingview_chart_data_response_result."ticks" is 'Values of the time axis given in milliseconds since UNIX epoch';
comment on column deribit.public_get_tradingview_chart_data_response_result."volume" is 'List of volume bars (in base currency, one per candle)';

create type deribit.public_get_tradingview_chart_data_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_tradingview_chart_data_response_result
);

comment on column deribit.public_get_tradingview_chart_data_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_tradingview_chart_data_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_get_tradingview_chart_data(
    "instrument_name" text,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "resolution" deribit.public_get_tradingview_chart_data_request_resolution
)
returns deribit.public_get_tradingview_chart_data_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name",
            "start_timestamp",
            "end_timestamp",
            "resolution"
        )::deribit.public_get_tradingview_chart_data_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_tradingview_chart_data'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_tradingview_chart_data_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_tradingview_chart_data is 'Publicly available market data used to generate a TradingView candle chart.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_get_volatility_index_data_request_currency as enum (
    'BTC',
    'ETH',
    'EURR',
    'USDC',
    'USDT'
);

create type deribit.public_get_volatility_index_data_request_resolution as enum (
    '1',
    '1D',
    '3600',
    '43200',
    '60'
);

create type deribit.public_get_volatility_index_data_request as (
    "currency" deribit.public_get_volatility_index_data_request_currency,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "resolution" deribit.public_get_volatility_index_data_request_resolution
);

comment on column deribit.public_get_volatility_index_data_request."currency" is '(Required) The currency symbol';
comment on column deribit.public_get_volatility_index_data_request."start_timestamp" is '(Required) The earliest timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_volatility_index_data_request."end_timestamp" is '(Required) The most recent timestamp to return result from (milliseconds since the UNIX epoch)';
comment on column deribit.public_get_volatility_index_data_request."resolution" is '(Required) Time resolution given in full seconds or keyword 1D (only some specific resolutions are supported)';

create type deribit.public_get_volatility_index_data_response_result as (
    "continuation" bigint,
    "data" text[]
);

comment on column deribit.public_get_volatility_index_data_response_result."continuation" is 'Continuation - to be used as the end_timestamp parameter on the next request. NULL when no continuation.';
comment on column deribit.public_get_volatility_index_data_response_result."data" is 'Candles as an array of arrays with 5 values each. The inner values correspond to the timestamp in ms, open, high, low, and close values of the volatility index correspondingly.';

create type deribit.public_get_volatility_index_data_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_get_volatility_index_data_response_result
);

comment on column deribit.public_get_volatility_index_data_response."id" is 'The id that was sent in the request';
comment on column deribit.public_get_volatility_index_data_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.public_get_volatility_index_data_response."result" is 'Volatility index candles.';

create function deribit.public_get_volatility_index_data(
    "currency" deribit.public_get_volatility_index_data_request_currency,
    "start_timestamp" bigint,
    "end_timestamp" bigint,
    "resolution" deribit.public_get_volatility_index_data_request_resolution
)
returns deribit.public_get_volatility_index_data_response_result
language sql
as $$
    
    with request as (
        select row(
            "currency",
            "start_timestamp",
            "end_timestamp",
            "resolution"
        )::deribit.public_get_volatility_index_data_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/get_volatility_index_data'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_get_volatility_index_data_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_get_volatility_index_data is 'Public market data request for volatility index candles.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_status_response_result as (
    "locked" text,
    "locked_currencies" text[]
);

comment on column deribit.public_status_response_result."locked" is 'true when platform is locked in all currencies, partial when some currencies are locked, false - when there are not currencies locked';
comment on column deribit.public_status_response_result."locked_currencies" is 'List of currencies in which platform is locked';

create type deribit.public_status_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_status_response_result
);

comment on column deribit.public_status_response."id" is 'The id that was sent in the request';
comment on column deribit.public_status_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_status()
returns deribit.public_status_response_result
language sql
as $$
    with http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/status'::deribit.endpoint,
            request := null::text,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
    select (
        jsonb_populate_record(
            null::deribit.public_status_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_status is 'Method used to get information about locked currencies';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_test_request_expected_result as enum (
    'exception'
);

create type deribit.public_test_request as (
    "expected_result" deribit.public_test_request_expected_result
);

comment on column deribit.public_test_request."expected_result" is 'The value "exception" will trigger an error response. This may be useful for testing wrapper libraries.';

create type deribit.public_test_response_result as (
    "version" text
);

comment on column deribit.public_test_response_result."version" is 'The API version';

create type deribit.public_test_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_test_response_result
);

comment on column deribit.public_test_response."id" is 'The id that was sent in the request';
comment on column deribit.public_test_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_test(
    "expected_result" deribit.public_test_request_expected_result default null
)
returns deribit.public_test_response_result
language sql
as $$
    
    with request as (
        select row(
            "expected_result"
        )::deribit.public_test_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/test'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_test_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_test is 'Tests the connection to the API server, and returns its version. You can use this to make sure the API is reachable, and matches the expected version.';
/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.public_ticker_request as (
    "instrument_name" text
);

comment on column deribit.public_ticker_request."instrument_name" is '(Required) Instrument name';

create type deribit.public_ticker_response_stats as (
    "high" double precision,
    "low" double precision,
    "price_change" double precision,
    "volume" double precision,
    "volume_usd" double precision
);

comment on column deribit.public_ticker_response_stats."high" is 'Highest price during 24h';
comment on column deribit.public_ticker_response_stats."low" is 'Lowest price during 24h';
comment on column deribit.public_ticker_response_stats."price_change" is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_ticker_response_stats."volume" is 'Volume during last 24h in base currency';
comment on column deribit.public_ticker_response_stats."volume_usd" is 'Volume in usd (futures only)';

create type deribit.public_ticker_response_greeks as (
    "delta" double precision,
    "gamma" double precision,
    "rho" double precision,
    "theta" double precision,
    "vega" double precision
);

comment on column deribit.public_ticker_response_greeks."delta" is '(Only for option) The delta value for the option';
comment on column deribit.public_ticker_response_greeks."gamma" is '(Only for option) The gamma value for the option';
comment on column deribit.public_ticker_response_greeks."rho" is '(Only for option) The rho value for the option';
comment on column deribit.public_ticker_response_greeks."theta" is '(Only for option) The theta value for the option';
comment on column deribit.public_ticker_response_greeks."vega" is '(Only for option) The vega value for the option';

create type deribit.public_ticker_response_result as (
    "ask_iv" double precision,
    "best_ask_amount" double precision,
    "best_ask_price" double precision,
    "best_bid_amount" double precision,
    "best_bid_price" double precision,
    "bid_iv" double precision,
    "current_funding" double precision,
    "delivery_price" double precision,
    "estimated_delivery_price" double precision,
    "funding_8h" double precision,
    "greeks" deribit.public_ticker_response_greeks,
    "index_price" double precision,
    "instrument_name" text,
    "interest_rate" double precision,
    "interest_value" double precision,
    "last_price" double precision,
    "mark_iv" double precision,
    "mark_price" double precision,
    "max_price" double precision,
    "min_price" double precision,
    "open_interest" double precision,
    "settlement_price" double precision,
    "state" text,
    "stats" deribit.public_ticker_response_stats,
    "timestamp" bigint,
    "underlying_index" text,
    "underlying_price" double precision
);

comment on column deribit.public_ticker_response_result."ask_iv" is '(Only for option) implied volatility for best ask';
comment on column deribit.public_ticker_response_result."best_ask_amount" is 'It represents the requested order size of all best asks';
comment on column deribit.public_ticker_response_result."best_ask_price" is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_ticker_response_result."best_bid_amount" is 'It represents the requested order size of all best bids';
comment on column deribit.public_ticker_response_result."best_bid_price" is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_ticker_response_result."bid_iv" is '(Only for option) implied volatility for best bid';
comment on column deribit.public_ticker_response_result."current_funding" is 'Current funding (perpetual only)';
comment on column deribit.public_ticker_response_result."delivery_price" is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_ticker_response_result."estimated_delivery_price" is 'Estimated delivery price for the market. For more details, see Contract Specification > General Documentation > Expiration Price';
comment on column deribit.public_ticker_response_result."funding_8h" is 'Funding 8h (perpetual only)';
comment on column deribit.public_ticker_response_result."greeks" is 'Only for options';
comment on column deribit.public_ticker_response_result."index_price" is 'Current index price';
comment on column deribit.public_ticker_response_result."instrument_name" is 'Unique instrument identifier';
comment on column deribit.public_ticker_response_result."interest_rate" is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_ticker_response_result."interest_value" is 'Value used to calculate realized_funding in positions (perpetual only)';
comment on column deribit.public_ticker_response_result."last_price" is 'The price for the last trade';
comment on column deribit.public_ticker_response_result."mark_iv" is '(Only for option) implied volatility for mark price';
comment on column deribit.public_ticker_response_result."mark_price" is 'The mark price for the instrument';
comment on column deribit.public_ticker_response_result."max_price" is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.public_ticker_response_result."min_price" is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.public_ticker_response_result."open_interest" is 'The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is the amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_ticker_response_result."settlement_price" is 'Optional (not added for spot). The settlement price for the instrument. Only when state = open';
comment on column deribit.public_ticker_response_result."state" is 'The state of the order book. Possible values are open and closed.';
comment on column deribit.public_ticker_response_result."timestamp" is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_ticker_response_result."underlying_index" is 'Name of the underlying future, or index_price (options only)';
comment on column deribit.public_ticker_response_result."underlying_price" is 'Underlying price for implied volatility calculations (options only)';

create type deribit.public_ticker_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" deribit.public_ticker_response_result
);

comment on column deribit.public_ticker_response."id" is 'The id that was sent in the request';
comment on column deribit.public_ticker_response."jsonrpc" is 'The JSON-RPC version (2.0)';

create function deribit.public_ticker(
    "instrument_name" text
)
returns deribit.public_ticker_response_result
language sql
as $$
    
    with request as (
        select row(
            "instrument_name"
        )::deribit.public_ticker_request as payload
    ), 
    http_response as (
        select deribit.public_jsonrpc_request(
            url := '/public/ticker'::deribit.endpoint,
            request := request.payload,
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
    select (
        jsonb_populate_record(
            null::deribit.public_ticker_response,
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
    from http_response a

$$;

comment on function deribit.public_ticker is 'Get ticker for an instrument.';
