create or replace function deribit.private_change_margin_model(
	user_id bigint default null,
	margin_model deribit.private_change_margin_model_request_margin_model,
	dry_run boolean default null
)
returns setof deribit.private_change_margin_model_response_result
language plpgsql
as $$
declare
	_request deribit.private_change_margin_model_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		user_id,
		margin_model,
		dry_run
    )::deribit.private_change_margin_model_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/change_margin_model', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.private_change_margin_model_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.private_change_margin_model is 'Change margin model';

