drop function if exists deribit.public_get_order_book_by_instrument_id;

create or replace function deribit.public_get_order_book_by_instrument_id(
	instrument_id bigint,
	depth deribit.public_get_order_book_by_instrument_id_request_depth default null
)
returns deribit.public_get_order_book_by_instrument_id_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_id,
			depth
        )::deribit.public_get_order_book_by_instrument_id_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_order_book_by_instrument_id'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_order_book_by_instrument_id_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_order_book_by_instrument_id is 'Retrieves the order book, along with other market values for a given instrument ID.';

