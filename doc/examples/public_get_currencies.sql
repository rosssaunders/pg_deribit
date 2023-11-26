select *
from deribit.public_get_currencies();

select * from deribit.public_get_order_book('BTC-PERPETUAL', 10);

select * from deribit.public_get_order(1, 100);