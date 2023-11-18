insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private_close_position', null, 0, '0 secs'::interval)
on conflict do nothing;

