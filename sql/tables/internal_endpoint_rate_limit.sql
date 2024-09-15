create table deribit.internal_endpoint_rate_limit (
    key deribit.endpoint primary key,
    last_call timestamptz null default null,
    total_call_count bigint not null default 0,
    total_calls_rate_limited_count bigint not null default 0,
    total_rate_limiting_waiting interval not null default '0 seconds',
    min_rate_limiting_waiting interval not null default '0 seconds',
    max_rate_limiting_waiting interval not null default '0 seconds'
);
