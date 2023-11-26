select (t."order").order_id
from generate_series(1, 10) s
left join lateral deribit.private_buy('ETH-PERPETUAL', s.s, 'market') t on true;

select (pb."order").*
from deribit.private_buy('ETH-PERPETUAL', 10, 'market') pb;

select *
from deribit.private_cancel_all(false);

select *
from deribit.private_close_position('ETH-PERPETUAL', 'market');

select (t."order").order_id
from deribit.private_sell('ETH-PERPETUAL', 10, 'limit', price := 10000) t;

select t as result
from deribit.private_cancel_all() t;
