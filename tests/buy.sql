-- drop type if exists BuyRequest;
-- create type BuyRequest as
-- (
--     instrument_name  text,
--     amount           numeric
-- );
--
-- select to_json(((x.a)::BuyRequest))
-- from (
-- values
--     (row('x', 10)::BuyRequest),
--     (row('x', 10)::BuyRequest)
-- ) x(a);

create or replace function execute_order()
returns trigger
language 'plpgsql'
as $$
declare
    id text;
begin





    return NEW;
end;
$$;

create trigger execute_order
    before insert
    on "order"
    for each row
execute procedure execute_order();

select *
from "order";


delete from "order" where true;

insert into "order" (id, instrument, amount, "limit")
select gen_random_uuid(), 'ETH-PERPETUAL', a.a, 1000
from generate_series(1,10) a;
select * from "order";



select t.*
from deribit.private_buy('ETH-PERPETUAL', 10, 'limit', price := 1000) t;

select deribit.private_cancel_all();

select deribit.private_close_position('ETH-PERPETUAL',
       type := 'market');

