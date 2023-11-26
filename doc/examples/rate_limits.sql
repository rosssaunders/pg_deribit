select (t.order).*
from generate_series(1, 1000, 1) s(amount)
left join lateral deribit.private_buy('ETH-PERPETUAL', s.amount, 'market') t on true
order by s.amount desc;

select *
from deribit.internal_archive

select *
from deribit.matching_engine_request_call_log
order by call_timestamp;

select *
from deribit.internal_endpoint_rate_limit
where key = '/private/buy';

-- loop from 1 to 100
do $$
DECLARE
   counter INTEGER := 0;
begin
   LOOP
      EXIT WHEN counter = 100; -- condition to stop the loop
      RAISE NOTICE 'Counter: %', counter; -- print the counter value
      counter := counter + 1; -- increment the counter

       perform * from deribit.private_buy('ETH-PERPETUAL', 10, 'market') t;
   END LOOP;
end;
$$

select (t.order).order_id
from generate_series(0, 100) s
left join lateral deribit.private_buy('ETH-PERPETUAL', 10, 'market') t on true;


