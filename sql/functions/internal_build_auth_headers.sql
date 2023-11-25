create or replace function deribit.internal_build_auth_headers()
returns omni_http.http_header
language sql
as $$
    select (
        'Authorization',
        'Basic ' || encode(((select current_setting('deribit.client_id')) || ':' || (select current_setting('deribit.client_secret')))::bytea, 'base64')
    )::omni_http.http_header
    limit 1
$$;
