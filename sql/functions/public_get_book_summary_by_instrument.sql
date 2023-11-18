create or replace function deribit.public_get_book_summary_by_instrument(
	instrument_name text
)
returns setof deribit.public_get_book_summary_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_book_summary_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name
    )::deribit.public_get_book_summary_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_book_summary_by_instrument', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.public_get_book_summary_by_instrument_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.public_get_book_summary_by_instrument is 'Retrieves the summary information such as open interest, 24h volume, etc. for a specific instrument.';

