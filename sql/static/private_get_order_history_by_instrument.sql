insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/private/get_order_history_by_instrument', null, 0, '0 secs'::interval)
on conflict do nothing;

