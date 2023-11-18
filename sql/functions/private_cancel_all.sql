create or replace function deribit.private_cancel_all(
	detailed boolean default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_all_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		detailed
    )::deribit.private_cancel_all_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_all', _request);

    return (jsonb_populate_record(
        null::deribit.private_cancel_all_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_all is 'This method cancels all users orders and trigger orders within all currencies and instrument kinds.';

