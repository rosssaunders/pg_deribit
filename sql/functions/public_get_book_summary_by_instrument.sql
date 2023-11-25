drop function if exists deribit.public_get_book_summary_by_instrument;

create or replace function deribit.public_get_book_summary_by_instrument(
	instrument_name text
)
returns setof deribit.public_get_book_summary_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name
        )::deribit.public_get_book_summary_by_instrument_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_book_summary_by_instrument'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_book_summary_by_instrument_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).ask_price::double precision,
		(b).base_currency::text,
		(b).bid_price::double precision,
		(b).creation_timestamp::bigint,
		(b).current_funding::double precision,
		(b).estimated_delivery_price::double precision,
		(b).funding_8h::double precision,
		(b).high::double precision,
		(b).instrument_name::text,
		(b).interest_rate::double precision,
		(b).last::double precision,
		(b).low::double precision,
		(b).mark_price::double precision,
		(b).mid_price::double precision,
		(b).open_interest::double precision,
		(b).price_change::double precision,
		(b).quote_currency::text,
		(b).underlying_index::text,
		(b).underlying_price::double precision,
		(b).volume::double precision,
		(b).volume_notional::double precision,
		(b).volume_usd::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_book_summary_by_instrument is 'Retrieves the summary information such as open interest, 24h volume, etc. for a specific instrument.';

