drop function if exists deribit.public_get_funding_rate_history;

create or replace function deribit.public_get_funding_rate_history(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns setof deribit.public_get_funding_rate_history_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			start_timestamp,
			end_timestamp
        )::deribit.public_get_funding_rate_history_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_funding_rate_history'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_funding_rate_history_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).index_price::double precision,
		(b).interest_1h::double precision,
		(b).interest_8h::double precision,
		(b).prev_index_price::double precision,
		(b).timestamp::bigint
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_funding_rate_history is 'Retrieves hourly historical interest rate for requested PERPETUAL instrument.';

