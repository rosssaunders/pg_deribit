------------------------------------------------------------------------
-- Examples of how to call to place orders using generate_series
------------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

select deribit.set_client_auth('<CLIENT_ID>', '<CLIENT_SECRET>');
select deribit.enable_test_net();

select (t."order").*
from generate_series(1, 10) as s(i)
left join lateral deribit.private_buy(
    instrument_name := 'BTC-PERPETUAL',
    amount := 100,
    type := 'limit',
    time_in_force := 'good_til_cancelled',
    post_only := true,
    price := 81200.5,
    reject_post_only := false,
    label := s.i::text
) as t on true;

select *
from deribit.private_cancel_all(false);

select *
from deribit.private_close_position('BTC-PERPETUAL', 'market');
