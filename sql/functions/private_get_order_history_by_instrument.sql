drop function if exists deribit.private_get_order_history_by_instrument;

create or replace function deribit.private_get_order_history_by_instrument(
	instrument_name text,
	count bigint default null,
	"offset" bigint default null,
	include_old boolean default null,
	include_unfilled boolean default null
)
returns setof deribit.private_get_order_history_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_order_history_by_instrument_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name,
		count,
		"offset",
		include_old,
		include_unfilled
    )::deribit.private_get_order_history_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_order_history_by_instrument'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_order_history_by_instrument_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_order_history_by_instrument is 'Retrieves history of orders that have been partially or fully filled.';

