create or replace function deribit.internal_url_endpoint(url deribit.endpoint)
returns text
language sql
as $$
    select format('%s%s', base_url, end_point) as url
    from
    (
        select
            'https://test.deribit.com/api/v2' as base_url,
            url as end_point
    ) as a
    limit 1
$$;
