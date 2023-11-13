select (t."order").order_id
from deribit.private_buy('ETH-PERPETUAL', 10, 'limit', price := 1000) t;

select (t."order").order_id
from deribit.private_sell('ETH-PERPETUAL', 10, 'limit', price := 10000) t;

select t as result
from deribit.private_cancel_all() t;
