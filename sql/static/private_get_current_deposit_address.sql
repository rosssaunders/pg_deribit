insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/private/get_current_deposit_address', null, 0, '0 secs'::interval)
on conflict do nothing;

