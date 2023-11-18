create table deribit.internal_endpoint_rate_limit (
    key text primary key,
    last_call timestamptz null,
    calls int not null default 0,
    calls_rate_limited int not null default 0,
    time_waiting interval not null default '0 seconds',
    limit_per_second int not null default '0'
);
