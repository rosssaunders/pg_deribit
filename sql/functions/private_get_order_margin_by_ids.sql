drop function if exists deribit.private_get_order_margin_by_ids;

create or replace function deribit.private_get_order_margin_by_ids(
	ids UNKNOWN - array - False - False - False
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
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_order_margin_by_ids'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_order_margin_by_ids_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_order_margin_by_ids is 'Retrieves initial margins of given orders';

