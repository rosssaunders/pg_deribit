insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public_get_tradingview_chart_data', null, 0, '0 secs'::interval)
on conflict do nothing;

