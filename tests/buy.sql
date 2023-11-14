select (t."order").order_id
from deribit.private_buy('ETH-PERPETUAL', 10, 'limit', price := 1000) t;

select (t."order").order_id
from deribit.private_sell('ETH-PERPETUAL', 10, 'limit', price := 10000) t;

select t as result
from deribit.private_cancel_all() t;

select request, convert_from((response ->> 'body')::bytea, 'utf-8'::text)::jsonb
from deribit.internal_archive;