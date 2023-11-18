insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/public/get_last_trades_by_currency_and_time', null, 0, '0 secs'::interval)
on conflict do nothing;

