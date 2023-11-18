create or replace function deribit.private_get_open_orders_by_instrument(
	instrument_name text,
	type deribit.private_get_open_orders_by_instrument_request_type default null
)
returns setof deribit.private_get_open_orders_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_open_orders_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		type
    )::deribit.private_get_open_orders_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_open_orders_by_instrument', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.private_get_open_orders_by_instrument_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.private_get_open_orders_by_instrument is 'Retrieves list of user''s open orders within given Instrument.';

