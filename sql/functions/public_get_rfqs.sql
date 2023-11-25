drop function if exists deribit.public_get_rfqs;

create or replace function deribit.public_get_rfqs(
	currency deribit.public_get_rfqs_request_currency,
	kind deribit.public_get_rfqs_request_kind default null
)
returns setof deribit.public_get_rfqs_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_rfqs_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		kind
    )::deribit.public_get_rfqs_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_rfqs'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_rfqs_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_rfqs is 'Retrieve active RFQs for instruments in given currency.';

