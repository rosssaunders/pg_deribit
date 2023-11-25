drop function if exists deribit.private_cancel_by_label;

create or replace function deribit.private_cancel_by_label(
	label text,
	currency deribit.private_cancel_by_label_request_currency default null
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
			label,
			currency
        )::deribit.private_cancel_by_label_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/cancel_by_label'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_cancel_by_label_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel_by_label is 'Cancels orders by label. All user''s orders (trigger orders too), with given label are canceled in all currencies or in one given currency (in this case currency queue is used) ';

