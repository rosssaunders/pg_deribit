create or replace function deribit.private_get_order_margin_by_ids(
	ids text[]
)
returns setof deribit.private_get_order_margin_by_ids_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_order_margin_by_ids_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		ids
    )::deribit.private_get_order_margin_by_ids_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_order_margin_by_ids', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.private_get_order_margin_by_ids_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.private_get_order_margin_by_ids is 'Retrieves initial margins of given orders';

