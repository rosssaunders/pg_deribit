deallocate matching_engine_request_log_call;

prepare matching_engine_request_log_call (deribit.endpoint) as
select deribit.matching_engine_request_log_call('/private/buy'::deribit.endpoint);

select (t."order").order_id
from generate_series(1, 10) s
left join lateral deribit.private_buy('ETH-PERPETUAL', s.s, 'market') t on true;


select *
from deribit.internal_endpoint_rate_limit
order by total_call_count desc;

select *
from deribit.internal_endpoint_rate_limit
where key in ('/private/sell', '/private/buy');

select *
from deribit.private_cancel_all(false);

select *
from deribit.private_close_position('ETH-PERPETUAL', 'market');

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
from deribit.internal_archive;

select *
from generate_series(0, 1000)
cross join deribit.internal_rate_limit('private/buy');
