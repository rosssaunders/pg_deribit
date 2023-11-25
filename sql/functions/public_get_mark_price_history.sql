drop function if exists deribit.public_get_mark_price_history;

create or replace function deribit.public_get_mark_price_history(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns setof deribit.public_get_mark_price_history_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			start_timestamp,
			end_timestamp
        )::deribit.public_get_mark_price_history_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_mark_price_history'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
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

comment on function deribit.public_get_mark_price_history is 'Public request for 5min history of markprice values for the instrument. For now the markprice history is available only for a subset of options which take part in the volatility index calculations. All other instruments, futures and perpetuals will return empty list.';

