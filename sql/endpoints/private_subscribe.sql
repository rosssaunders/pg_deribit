/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
create type deribit.private_subscribe_request as (
    "channels" text[],
    "label" text
);

comment on column deribit.private_subscribe_request."channels" is '(Required) A list of channels to subscribe to.';
comment on column deribit.private_subscribe_request."label" is 'Optional label which will be added to notifications of private channels (max 16 characters).';

create type deribit.private_subscribe_response as (
    "id" bigint,
    "jsonrpc" text,
    "result" text[]
);

comment on column deribit.private_subscribe_response."id" is 'The id that was sent in the request';
comment on column deribit.private_subscribe_response."jsonrpc" is 'The JSON-RPC version (2.0)';
comment on column deribit.private_subscribe_response."result" is 'A list of subscribed channels.';

create function deribit.private_subscribe(
    auth deribit.auth
,    "channels" text[],
    "label" text default null
)
returns setof text
language sql
as $$
    
    with request as (
        select row(
            "channels",
            "label"
        )::deribit.private_subscribe_request as payload
    ), 
    http_response as (
        select deribit.private_jsonrpc_request(
            auth := auth,             
            url := '/private/subscribe'::deribit.endpoint, 
            request := request.payload, 
            rate_limiter := 'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
        , result as (
select (jsonb_populate_record(
                        null::deribit.private_subscribe_response,
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

comment on function deribit.private_subscribe is 'Subscribe to one or more channels.';
