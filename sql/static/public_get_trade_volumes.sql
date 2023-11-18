insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/public/get_trade_volumes', null, 0, '0 secs'::interval)
on conflict do nothing;

