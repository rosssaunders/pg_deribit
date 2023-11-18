

/*
select *
from generate_series(0, 100) s
left join lateral deribit.matching_engine_request_log_call('private/buy', s.s) on true
cross join deribit.private_buy('ETH-PERPETUAL', 10, 'market') t
order by s.s desc;

select *
from deribit.matching_engine_request_call_log
order by call_timestamp;

select *
from deribit.internal_endpoint_rate_limit
where key = 'private/buy';

alter table deribit.internal_endpoint_rate_limit
add column calls_rate_limited bigint not null default 0;
*/



