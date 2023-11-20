create or replace function deribit.test_private_change_margin_model()
returns setof text
language plpgsql
as $$
declare
    _expected setof deribit.private_change_margin_model_response_result;
    
	_user_id bigint = null;
	_margin_model deribit.private_change_margin_model_request_margin_model;
	_dry_run boolean = null;

begin
    _expected := deribit.private_change_margin_model(
		user_id := _user_id,
		margin_model := _margin_model,
		dry_run := _dry_run
    );
    
    return query (
        select results_eq(_result, _expected)
    );
end
$$;

