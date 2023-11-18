select (t."order").order_id
from generate_series(1, 300) s
cross join deribit.private_buy('ETH-PERPETUAL', s.s, 'market') t;

select s.s
from generate_series(1,50) s;

select (t."order").order_id
from deribit.private_sell('ETH-PERPETUAL', 10, 'limit', price := 10000) t;

select t as result
from deribit.private_cancel_all() t;

select request, convert_from((response ->> 'body')::bytea, 'utf-8'::text)::jsonb, *
from deribit.internal_archive
order by id desc;

select *
from deribit.internal_endpoint_rate_limit
where key = 'private/buy';


select *
from generate_series(0, 1000)
cross join deribit.internal_rate_limit('private/buy');



with src as (
        select
            case
                when (limit_per_second / 60) > diff_last_call then (limit_per_second / 60) - diff_last_call
                else 0
            end as rate_limit_delay,
            limit_per_second,
            diff_last_call
        from (
            select
                extract(second from current_timestamp - coalesce(last_call, current_timestamp)) as diff_last_call,
                limit_per_second
            from deribit.internal_endpoint_rate_limit
            where key = 'private/buy'
        ) a
    )
    select src.rate_limit_delay
    from src
    limit 1;