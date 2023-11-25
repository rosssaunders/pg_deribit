drop function if exists deribit.private_edit_by_label;

create or replace function deribit.private_edit_by_label(
	instrument_name text,
	amount double precision,
	label text default null,
	price double precision default null,
	post_only boolean default null,
	reduce_only boolean default null,
	reject_post_only boolean default null,
	advanced deribit.private_edit_by_label_request_advanced default null,
	trigger_price double precision default null,
	mmp boolean default null,
	valid_until bigint default null
)
returns deribit.private_edit_by_label_response_result
language sql
as $$
    
    with request as (
        select row(
			label,
			instrument_name,
			amount,
			price,
			post_only,
			reduce_only,
			reject_post_only,
			advanced,
			trigger_price,
			mmp,
			valid_until
        )::deribit.private_edit_by_label_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/edit_by_label'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_edit_by_label_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_edit_by_label is 'Change price, amount and/or other properties of an order with given label. It works only when there is one open order with this label';

