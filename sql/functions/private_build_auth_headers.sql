create function deribit.private_build_auth_headers(auth deribit.auth)
returns omni_http.http_header
language sql
as $$
    select (
        'Authorization',
        case 
            when auth.client_id is not null then
                'Basic ' || encode(
                    (
                        format('%s:%s', auth.client_id, auth.client_secret)
                    )::bytea, 'base64'
                )
            else 
                'Bearer ' || auth.access_token
        end
    )::omni_http.http_header
    limit 1
$$;

comment on function deribit.private_build_auth_headers is 'Internal function to build deribit API authentication headers';
