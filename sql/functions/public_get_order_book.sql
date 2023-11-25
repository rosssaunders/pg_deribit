drop function if exists deribit.public_get_order_book;

create or replace function deribit.public_get_order_book(
	instrument_name text,
	depth deribit.public_get_order_book_request_depth default null
)
returns deribit.public_get_order_book_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			depth
        )::deribit.public_get_order_book_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_order_book'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_order_book_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_order_book is 'Retrieves the order book, along with other market values for a given instrument.';

