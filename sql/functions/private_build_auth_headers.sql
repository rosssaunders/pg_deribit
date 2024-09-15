create function deribit.private_build_auth_headers(auth deribit.auth)
returns omni_http.http_header
language sql
as $$
    select (
        'Authorization',
        'Basic ' || 
            encode(
                (
                    (select auth.client_id) ||
                    ':' ||
                    (select auth.client_secret)
                )::bytea, 'base64'
            )
    )::omni_http.http_header
    limit 1
$$;
