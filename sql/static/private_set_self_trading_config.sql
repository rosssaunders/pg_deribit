insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/private/set_self_trading_config', null, 0, '0 secs'::interval)
on conflict do nothing;

