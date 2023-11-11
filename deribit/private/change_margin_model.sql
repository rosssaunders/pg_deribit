create type deribit.private_change_margin_model_response_old_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float
);
comment on column deribit.private_change_margin_model_response_old_state.available_balance is 'Available balance before change';
comment on column deribit.private_change_margin_model_response_old_state.initial_margin_rate is 'Initial margin rate before change';
comment on column deribit.private_change_margin_model_response_old_state.maintenance_margin_rate is 'Maintenance margin rate before change';

create type deribit.private_change_margin_model_response_new_state as (
	available_balance float,
	initial_margin_rate float,
	maintenance_margin_rate float,
	old_state deribit.private_change_margin_model_response_old_state
);
comment on column deribit.private_change_margin_model_response_new_state.available_balance is 'Available balance after change';
comment on column deribit.private_change_margin_model_response_new_state.initial_margin_rate is 'Initial margin rate after change';
comment on column deribit.private_change_margin_model_response_new_state.maintenance_margin_rate is 'Maintenance margin rate after change';
comment on column deribit.private_change_margin_model_response_new_state.old_state is 'Represents portfolio state before change';

create type deribit.private_change_margin_model_response_result as (
	currency text,
	new_state deribit.private_change_margin_model_response_new_state
);
comment on column deribit.private_change_margin_model_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_change_margin_model_response_result.new_state is 'Represents portfolio state after change';

create type deribit.private_change_margin_model_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_change_margin_model_response_result[]
);
comment on column deribit.private_change_margin_model_response.id is 'The id that was sent in the request';
comment on column deribit.private_change_margin_model_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_change_margin_model_request_margin_model as enum ('cross_pm', 'cross_sm', 'segregated_pm', 'segregated_sm', 'legacy_pm');

create type deribit.private_change_margin_model_request as (
	user_id bigint,
	margin_model deribit.private_change_margin_model_request_margin_model,
	dry_run boolean
);
comment on column deribit.private_change_margin_model_request.user_id is 'Id of a (sub)account - by default current user id is used';
comment on column deribit.private_change_margin_model_request.margin_model is '(Required) Margin model';
comment on column deribit.private_change_margin_model_request.dry_run is 'If true request returns the result without switching the margining model. Default: false';

create or replace function deribit.private_change_margin_model(
	user_id bigint default null,
	margin_model deribit.private_change_margin_model_request_margin_model,
	dry_run boolean default null
)
returns deribit.private_change_margin_model_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
	_request deribit.private_change_margin_model_request;
    _error_response deribit.error_response;
begin
    _request := row(
		user_id,
		margin_model,
		dry_run
    )::deribit.private_change_margin_model_request;

    with request as (
        select json_build_object(
            'method', '/private/change_margin_model',
            'params', jsonb_strip_nulls(to_jsonb(_request)),
            'jsonrpc', '2.0',
            'id', nextval('deribit.jsonrpc_identifier'::regclass)
        ) as request
    ),
    auth as (
        select
            'Authorization' as key,
            'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value
    ),
    url as (
        select format('%s%s', base_url, end_point) as url
        from
        (
            select
                'https://test.deribit.com/api/v2' as base_url,
                '/private/change_margin_model' as end_point
        ) as a
    )
    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from request
    cross join auth
    cross join url
    cross join omni_httpc.http_execute(
        omni_httpc.http_request(
            method := 'POST',
            url := url.url,
            body := request.request::text::bytea,
            headers := array[row (auth.key, auth.value)::omni_http.http_header])
    ) as response
    limit 1;
    
    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
             case
                when (_error_response.error).data is null then ''
                 else ':' || (_error_response.error).data
             end;
    end if;
    
    return (jsonb_populate_record(
        null::deribit.private_change_margin_model_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function deribit.private_change_margin_model is 'Change margin model';

