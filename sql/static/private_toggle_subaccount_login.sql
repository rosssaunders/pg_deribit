insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/private/toggle_subaccount_login', null, 0, '0 secs'::interval)
on conflict do nothing;

