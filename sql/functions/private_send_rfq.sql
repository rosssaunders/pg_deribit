drop function if exists deribit.private_send_rfq;

create or replace function deribit.private_send_rfq(
	instrument_name text,
	amount float default null,
	side deribit.private_send_rfq_request_side default null
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_send_rfq_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name,
		amount,
		side
    )::deribit.private_send_rfq_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/send_rfq'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_send_rfq_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';

