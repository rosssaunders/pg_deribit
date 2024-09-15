create function deribit.unnest_2d_1d(anyarray)
returns setof anyarray
language sql
immutable parallel safe strict as
$$
select array_agg($1[d1][d2])
from generate_subscripts($1, 1) d1,
    generate_subscripts($1, 2) d2
group by d1
order by d1
$$;

comment on function deribit.unnest_2d_1d(anyarray) is 'Unnest a 2d array into a 1d array. Used for Market Data.';
