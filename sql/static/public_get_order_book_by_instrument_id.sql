insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public_get_order_book_by_instrument_id', null, 0, '0 secs'::interval)
on conflict do nothing;

