drop function if exists deribit.public_get_currencies;

create or replace function deribit.public_get_currencies()
returns setof deribit.public_get_currencies_response_result
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_currencies'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_currencies_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).coin_type::text,
		(b).currency::text,
		(b).currency_long::text,
		(b).fee_precision::bigint,
		(b).min_confirmations::bigint,
		(b).min_withdrawal_fee::double precision,
		(b).withdrawal_fee::double precision,
		(b).withdrawal_priorities::deribit.public_get_currencies_response_withdrawal_priority[]
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_currencies is 'Retrieves all cryptocurrencies supported by the API.';

