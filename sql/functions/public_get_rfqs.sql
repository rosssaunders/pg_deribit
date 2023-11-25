drop function if exists deribit.public_get_rfqs;

create or replace function deribit.public_get_rfqs(
	currency deribit.public_get_rfqs_request_currency,
	kind deribit.public_get_rfqs_request_kind default null
)
returns setof deribit.public_get_rfqs_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			kind
        )::deribit.public_get_rfqs_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_rfqs'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.public_get_rfqs_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).amount::double precision,
		(b).instrument_name::text,
		(b).last_rfq_timestamp::bigint,
		(b).side::text,
		(b).traded_volume::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.public_get_rfqs is 'Retrieve active RFQs for instruments in given currency.';

