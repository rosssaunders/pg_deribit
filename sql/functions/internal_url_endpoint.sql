create function deribit.internal_url_endpoint(url deribit.endpoint)
returns text
language sql
as $$
    select format('%s%s', base_url, end_point) as url
    from
    (
        select
            case 
                when current_setting('deribit.set_test_net', true) = 'true' then 'https://test.deribit.com/api/v2'
                else 'https://www.deribit.com/api/v2'
            end as base_url,
            url as end_point
    ) as a
$$;

comment on function deribit.internal_url_endpoint is 'Internal function to get deribit API endpoint URL';
