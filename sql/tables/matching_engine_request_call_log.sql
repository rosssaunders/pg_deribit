create unlogged table deribit.matching_engine_request_call_log
(
    call_timestamp timestamp
);

alter table deribit.matching_engine_request_call_log set (
    autovacuum_vacuum_scale_factor = 0.05,
    autovacuum_vacuum_threshold = 50,
    autovacuum_analyze_scale_factor = 0.02,
    autovacuum_analyze_threshold = 50,
    autovacuum_vacuum_cost_delay = 10,
    autovacuum_vacuum_cost_limit = 2000
);

comment on table deribit.matching_engine_request_call_log is 'Internal log of deribit API requests';
