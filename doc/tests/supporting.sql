create extension if not exists pg_deribit cascade;

select deribit.public_get_time();

-- TODO - this doesn't match the spec
select *
from deribit.public_status();

select *
from deribit.public_test();
