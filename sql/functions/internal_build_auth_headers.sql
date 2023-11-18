create or replace function deribit.internal_build_auth_headers()
returns omni_http.http_header
language sql
as $$
    select (
        'Authorization',
        'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64')
    )::omni_http.http_header
    limit 1
$$;
