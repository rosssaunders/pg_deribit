drop function if exists deribit.private_get_user_trades_by_currency;

create or replace function deribit.private_get_user_trades_by_currency(
	currency deribit.private_get_user_trades_by_currency_request_currency,
	kind deribit.private_get_user_trades_by_currency_request_kind default null,
	start_id text default null,
	end_id text default null,
	count bigint default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	sorting deribit.private_get_user_trades_by_currency_request_sorting default null,
	subaccount_id bigint default null
)
returns deribit.private_get_user_trades_by_currency_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			kind,
			start_id,
			end_id,
			count,
			start_timestamp,
			end_timestamp,
			sorting,
			subaccount_id
        )::deribit.private_get_user_trades_by_currency_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_user_trades_by_currency'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_currency_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_user_trades_by_currency is 'Retrieve the latest user trades that have occurred for instruments in a specific currency symbol. To read subaccount trades, use subaccount_id parameter.';

