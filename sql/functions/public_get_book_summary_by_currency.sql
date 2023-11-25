drop function if exists deribit.public_get_book_summary_by_currency;

create or replace function deribit.public_get_book_summary_by_currency(
	currency deribit.public_get_book_summary_by_currency_request_currency,
	kind deribit.public_get_book_summary_by_currency_request_kind default null
)
returns setof deribit.public_get_book_summary_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_book_summary_by_currency_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		kind
    )::deribit.public_get_book_summary_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_book_summary_by_currency'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_book_summary_by_currency_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_book_summary_by_currency is 'Retrieves the summary information such as open interest, 24h volume, etc. for all instruments for the currency (optionally filtered by kind).';

