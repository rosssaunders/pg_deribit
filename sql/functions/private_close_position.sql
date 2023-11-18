create or replace function deribit.private_close_position(
	instrument_name text,
	type deribit.private_close_position_request_type,
	price float default null
)
returns deribit.private_close_position_response_result
language plpgsql
as $$
declare
	_request deribit.private_close_position_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		type,
		price
    )::deribit.private_close_position_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/close_position', _request);

    return (jsonb_populate_record(
        null::deribit.private_close_position_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_close_position is 'Makes closing position reduce only order .';

