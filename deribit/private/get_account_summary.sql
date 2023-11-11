create type deribit.private_get_account_summary_response_options_theta_map as (
	creation_timestamp bigint,
	available_withdrawal_funds float,
	equity float,
	options_gamma float
);
comment on column deribit.private_get_account_summary_response_options_theta_map.creation_timestamp is 'Time at which the account was created (milliseconds since the Unix epoch; available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_theta_map.available_withdrawal_funds is 'The account''s available to withdrawal funds';
comment on column deribit.private_get_account_summary_response_options_theta_map.equity is 'The account''s current equity';
comment on column deribit.private_get_account_summary_response_options_theta_map.options_gamma is 'Options summary gamma';

create type deribit.private_get_account_summary_response_options_vega_map as (
	balance float,
	mmp_enabled boolean,
	projected_initial_margin float,
	email text,
	available_funds float,
	spot_reserve float,
	projected_delta_total float,
	portfolio_margining_enabled boolean,
	total_pl float,
	margin_balance float,
	options_theta_map deribit.private_get_account_summary_response_options_theta_map
);
comment on column deribit.private_get_account_summary_response_options_vega_map.balance is 'The account''s balance';
comment on column deribit.private_get_account_summary_response_options_vega_map.mmp_enabled is 'Whether MMP is enabled (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_vega_map.projected_initial_margin is 'Projected initial margin';
comment on column deribit.private_get_account_summary_response_options_vega_map.email is 'User email (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_vega_map.available_funds is 'The account''s available funds';
comment on column deribit.private_get_account_summary_response_options_vega_map.spot_reserve is 'The account''s balance reserved in active spot orders';
comment on column deribit.private_get_account_summary_response_options_vega_map.projected_delta_total is 'The sum of position deltas without positions that will expire during closest expiration';
comment on column deribit.private_get_account_summary_response_options_vega_map.portfolio_margining_enabled is 'true when portfolio margining is enabled for user';
comment on column deribit.private_get_account_summary_response_options_vega_map.total_pl is 'Profit and loss';
comment on column deribit.private_get_account_summary_response_options_vega_map.margin_balance is 'The account''s margin balance';
comment on column deribit.private_get_account_summary_response_options_vega_map.options_theta_map is 'Map of options'' thetas per index';

create type deribit.private_get_account_summary_response_options_gamma_map as (
	futures_pl float,
	currency text,
	options_value float,
	security_keys_enabled boolean,
	self_trading_extended_to_subaccounts text,
	projected_maintenance_margin float,
	options_vega float,
	session_rpl float,
	has_non_block_chain_equity boolean,
	system_name text,
	deposit_address text,
	futures_session_upl float,
	options_session_upl float,
	referrer_id text,
	options_theta float,
	login_enabled boolean,
	username text,
	interuser_transfers_enabled boolean,
	options_delta float,
	options_pl float,
	options_vega_map deribit.private_get_account_summary_response_options_vega_map
);
comment on column deribit.private_get_account_summary_response_options_gamma_map.futures_pl is 'Futures profit and Loss';
comment on column deribit.private_get_account_summary_response_options_gamma_map.currency is 'The selected currency';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_value is 'Options value';
comment on column deribit.private_get_account_summary_response_options_gamma_map.security_keys_enabled is 'Whether Security Key authentication is enabled (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.self_trading_extended_to_subaccounts is 'true if self trading rejection behavior is applied to trades between subaccounts (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.projected_maintenance_margin is 'Projected maintenance margin';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_vega is 'Options summary vega';
comment on column deribit.private_get_account_summary_response_options_gamma_map.session_rpl is 'Session realized profit and loss';
comment on column deribit.private_get_account_summary_response_options_gamma_map.has_non_block_chain_equity is 'Optional field returned with value true when user has non block chain equity that is excluded from proof of reserve calculations';
comment on column deribit.private_get_account_summary_response_options_gamma_map.system_name is 'System generated user nickname (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.deposit_address is 'The deposit address for the account (if available)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.futures_session_upl is 'Futures session unrealized profit and Loss';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_session_upl is 'Options session unrealized profit and Loss';
comment on column deribit.private_get_account_summary_response_options_gamma_map.referrer_id is 'Optional identifier of the referrer (of the affiliation program, and available when parameter extended = true), which link was used by this account at registration. It coincides with suffix of the affiliation link path after /reg-';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_theta is 'Options summary theta';
comment on column deribit.private_get_account_summary_response_options_gamma_map.login_enabled is 'Whether account is loginable using email and password (available when parameter extended = true and account is a subaccount)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.username is 'Account name (given by user) (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.interuser_transfers_enabled is 'true when the inter-user transfers are enabled for user (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_delta is 'Options summary delta';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_pl is 'Options profit and Loss';
comment on column deribit.private_get_account_summary_response_options_gamma_map.options_vega_map is 'Map of options'' vegas per index';

create type deribit.private_get_account_summary_response_perpetuals as (
	burst bigint,
	rate bigint,
	type text,
	initial_margin float,
	options_gamma_map deribit.private_get_account_summary_response_options_gamma_map
);
comment on column deribit.private_get_account_summary_response_perpetuals.burst is 'Maximal number of perpetual related matching engine requests allowed for user in burst mode';
comment on column deribit.private_get_account_summary_response_perpetuals.rate is 'Number of perpetual related matching engine requests per second allowed for user';
comment on column deribit.private_get_account_summary_response_perpetuals.type is 'Account type (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_perpetuals.initial_margin is 'The account''s initial margin';
comment on column deribit.private_get_account_summary_response_perpetuals.options_gamma_map is 'Map of options'' gammas per index';

create type deribit.private_get_account_summary_response_options as (
	burst bigint,
	rate bigint,
	perpetuals deribit.private_get_account_summary_response_perpetuals
);
comment on column deribit.private_get_account_summary_response_options.burst is 'Maximal number of options related matching engine requests allowed for user in burst mode';
comment on column deribit.private_get_account_summary_response_options.rate is 'Number of options related matching engine requests per second allowed for user';
comment on column deribit.private_get_account_summary_response_options.perpetuals is 'Field not included if limits for perpetuals are not set.';

create type deribit.private_get_account_summary_response_non_matching_engine as (
	burst bigint,
	rate bigint,
	options deribit.private_get_account_summary_response_options
);
comment on column deribit.private_get_account_summary_response_non_matching_engine.burst is 'Maximal number of non matching engine requests allowed for user in burst mode';
comment on column deribit.private_get_account_summary_response_non_matching_engine.rate is 'Number of non matching engine requests per second allowed for user';
comment on column deribit.private_get_account_summary_response_non_matching_engine.options is 'Field not included if limits for options are not set.';

create type deribit.private_get_account_summary_response_matching_engine as (
	burst bigint,
	rate bigint,
	non_matching_engine deribit.private_get_account_summary_response_non_matching_engine
);
comment on column deribit.private_get_account_summary_response_matching_engine.burst is 'Maximal number of matching engine requests allowed for user in burst mode';
comment on column deribit.private_get_account_summary_response_matching_engine.rate is 'Number of matching engine requests per second allowed for user';

create type deribit.private_get_account_summary_response_futures as (
	burst bigint,
	rate bigint,
	matching_engine deribit.private_get_account_summary_response_matching_engine
);
comment on column deribit.private_get_account_summary_response_futures.burst is 'Maximal number of futures related matching engine requests allowed for user in burst mode';
comment on column deribit.private_get_account_summary_response_futures.rate is 'Number of futures related matching engine requests per second allowed for user';

create type deribit.private_get_account_summary_response_limits as (
	futures deribit.private_get_account_summary_response_futures
);
comment on column deribit.private_get_account_summary_response_limits.futures is 'Field not included if limits for futures are not set.';

create type deribit.private_get_account_summary_response_fee as (
	currency text,
	fee_type text,
	instrument_type text,
	maker_fee float,
	taker_fee float,
	limits deribit.private_get_account_summary_response_limits
);
comment on column deribit.private_get_account_summary_response_fee.currency is 'The currency the fee applies to';
comment on column deribit.private_get_account_summary_response_fee.fee_type is 'Fee type - relative if fee is calculated as a fraction of base instrument fee, fixed if fee is calculated solely using user fee';
comment on column deribit.private_get_account_summary_response_fee.instrument_type is 'Type of the instruments the fee applies to - future for future instruments (excluding perpetual), perpetual for future perpetual instruments, option for options';
comment on column deribit.private_get_account_summary_response_fee.maker_fee is 'User fee as a maker';
comment on column deribit.private_get_account_summary_response_fee.taker_fee is 'User fee as a taker';

create type deribit.private_get_account_summary_response_result as (
	maintenance_margin float,
	delta_total float,
	id bigint,
	options_session_rpl float,
	self_trading_reject_mode text,
	futures_session_rpl float,
	session_upl float,
	fee_balance float
);
comment on column deribit.private_get_account_summary_response_result.maintenance_margin is 'The maintenance margin.';
comment on column deribit.private_get_account_summary_response_result.delta_total is 'The sum of position deltas';
comment on column deribit.private_get_account_summary_response_result.id is 'Account id (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result.options_session_rpl is 'Options session realized profit and Loss';
comment on column deribit.private_get_account_summary_response_result.self_trading_reject_mode is 'Self trading rejection behavior - reject_taker or cancel_maker (available when parameter extended = true)';
comment on column deribit.private_get_account_summary_response_result.futures_session_rpl is 'Futures session realized profit and Loss';
comment on column deribit.private_get_account_summary_response_result.session_upl is 'Session unrealized profit and loss';
comment on column deribit.private_get_account_summary_response_result.fee_balance is 'The account''s fee balance (it can be used to pay for fees)';

create type deribit.private_get_account_summary_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_account_summary_response_result,
	fees deribit.private_get_account_summary_response_fee[]
);
comment on column deribit.private_get_account_summary_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_account_summary_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_get_account_summary_response.fees is 'User fees in case of any discounts (available when parameter extended = true and user has any discounts)';

create type deribit.private_get_account_summary_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_get_account_summary_request as (
	currency deribit.private_get_account_summary_request_currency,
	subaccount_id bigint,
	extended boolean
);
comment on column deribit.private_get_account_summary_request.currency is '(Required) The currency symbol';
comment on column deribit.private_get_account_summary_request.subaccount_id is 'The user id for the subaccount';
comment on column deribit.private_get_account_summary_request.extended is 'Include additional fields';

create or replace function deribit.private_get_account_summary(
	currency deribit.private_get_account_summary_request_currency,
	subaccount_id bigint default null,
	extended boolean default null
)
returns deribit.private_get_account_summary_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_get_account_summary_request;
    _error_response deribit.error_response;
begin
    _request := row(
		currency,
		subaccount_id,
		extended
    )::deribit.private_get_account_summary_request;

    with request as (
        select json_build_object(
            'method', '/private/get_account_summary',
            'params', jsonb_strip_nulls(to_jsonb(_request)),
            'jsonrpc', '2.0',
            'id', nextval('deribit.jsonrpc_identifier'::regclass)
        ) as request
    ),
    auth as (
        select
            'Authorization' as key,
            'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value
    ),
    url as (
        select format('%s%s', base_url, end_point) as url
        from
        (
            select
                'https://test.deribit.com/api/v2' as base_url,
                '/private/get_account_summary' as end_point
        ) as a
    )
    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from request
    cross join auth
    cross join url
    cross join omni_httpc.http_execute(
        omni_httpc.http_request(
            method := 'POST',
            url := url.url,
            body := request.request::text::bytea,
            headers := array[row (auth.key, auth.value)::omni_http.http_header])
    ) as response
    limit 1;
    
    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
             case
                when (_error_response.error).data is null then ''
                 else ':' || (_error_response.error).data
             end;
    end if;
    
    return (jsonb_populate_record(
        null::deribit.private_get_account_summary_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_get_account_summary is 'Retrieves user account summary. To read subaccount summary use subaccount_id parameter.';

