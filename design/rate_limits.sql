with src as (
    select now() - last_call as rate_limit_interval
    from deribit.internal_endpoint_rate_limit
    where key = 'private/buy'
),
update as (
    update deribit.internal_endpoint_rate_limit
    set last_call = now(),
        calls = calls + 1
    where key = 'private/buy'
)
select pg_sleep(extract(second from rate_limit_interval))
from src
where rate_limit_interval <= '1 secs'::interval;
