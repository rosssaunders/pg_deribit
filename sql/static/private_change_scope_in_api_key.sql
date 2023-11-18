insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('/private/change_scope_in_api_key', null, 0, '0 secs'::interval)
on conflict do nothing;

