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
),
update as (
    update deribit.internal_endpoint_rate_limit
    set last_call = current_timestamp,
        calls = calls + 1,
        time_waiting = time_waiting + (select justify_interval(cast(rate_limit_delay::text || ' seconds' AS interval)) from src)
    where key = 'private/buy'
)
select pg_sleep(src.rate_limit_delay)
from src;

