-----------------------------------------------------------------------
-- Examples of how to call to get instrument static and live pricing
-----------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

select *
from deribit.public_get_currencies();
