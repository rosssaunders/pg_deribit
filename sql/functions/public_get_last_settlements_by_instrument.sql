drop function if exists deribit.public_get_last_settlements_by_instrument;

create or replace function deribit.public_get_last_settlements_by_instrument(
	instrument_name text,
	type deribit.public_get_last_settlements_by_instrument_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.public_get_last_settlements_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			type,
			count,
			continuation,
			search_start_timestamp
        )::deribit.public_get_last_settlements_by_instrument_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_last_settlements_by_instrument'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_last_settlements_by_instrument_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_last_settlements_by_instrument is 'Retrieves historical public settlement, delivery and bankruptcy events filtered by instrument name.';

