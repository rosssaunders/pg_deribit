insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private_cancel_all_by_kind_or_type', null, 0, '0 secs'::interval)
on conflict do nothing;

