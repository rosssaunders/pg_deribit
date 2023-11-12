create type deribit.private_get_order_margin_by_ids_response_result as (
	initial_margin float,
	initial_margin_currency text,
	order_id text
);
comment on column deribit.private_get_order_margin_by_ids_response_result.initial_margin is 'Initial margin of order';
comment on column deribit.private_get_order_margin_by_ids_response_result.initial_margin_currency is 'Currency of initial margin';
comment on column deribit.private_get_order_margin_by_ids_response_result.order_id is 'Unique order identifier';

create type deribit.private_get_order_margin_by_ids_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_order_margin_by_ids_response_result[]
);
comment on column deribit.private_get_order_margin_by_ids_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_order_margin_by_ids_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.private_get_order_margin_by_ids_request as (
	ids text[]
);
comment on column deribit.private_get_order_margin_by_ids_request.ids is '(Required) Ids of orders';

create or replace function deribit.private_get_order_margin_by_ids(
	ids text[]
)
returns deribit.private_get_order_margin_by_ids_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_order_margin_by_ids_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		ids
    )::deribit.private_get_order_margin_by_ids_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/get_order_margin_by_ids', _request));

    return (jsonb_populate_record(
        null::deribit.private_get_order_margin_by_ids_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_get_order_margin_by_ids is 'Retrieves initial margins of given orders';

