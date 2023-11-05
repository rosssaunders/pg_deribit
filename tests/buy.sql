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

    select
        (convert_from(body, 'utf-8')::jsonb)['result']['order']['order_id'] as deribit_order_id
        into id
    from
        omni_httpc.http_execute(
            omni_httpc.http_request(
                    method := 'POST',
                    url := 'https://test.deribit.com/api/v2/private/buy',
                    body := json_build_object(
                            'method', 'private/buy',
                            'params', json_build_object(
                                    'instrument_name', NEW.instrument,
                                    'amount', NEW.amount,
                                    'type', 'market',
                                    'price', NEW."limit"
                                      ),
                            'jsonrpc', '2.0',
                            'id', 3
                            )::text::bytea,
                    headers:=array[row('Authorization', 'Bearer 1698923964971.1T6ffNMK.N0foiBFsPgNWVlzoMYxNFkfaJop5PaOzqL4ieLeoHkSgmK-JrDxOGmiM3ykwUvGv1MRpMVQ2-f3NAzc7KCjN-alOoqohXp6xgOcUviEuou7Gf9cSyE7HG9JLxJ_SUX1pX9hagFIbXZ25hU8BJ1MD8WlS1slbF__s5m_bWTu17BDSyu9opiYZwJX4u9JDkx_SLL5-vtZZ9clA6kISromnXhHaYE9sMZTtgDyMVA-ABwPMlcE8V8epBupTHNfp4hSnlEeubYSpUTslnJCwa7VM')::omni_http.http_header])
        ) h;

    NEW.external_order_id = id;

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

