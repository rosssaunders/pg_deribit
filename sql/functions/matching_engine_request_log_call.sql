drop function if exists deribit.matching_engine_request_log_call;
create or replace function deribit.matching_engine_request_log_call(url deribit.endpoint)
returns void
language plpgsql
as
$$
declare
    _call_count int;
    _rate_per_second int = 10;
    _delay float = 0;
    _has_delay int = 0;
    _cleanup interval = interval '2 seconds';
begin

    -- Insert the current timestamp into the temporary table
    insert into deribit.matching_engine_request_call_log(call_timestamp) values (clock_timestamp());

    -- Count the number of calls in the last second
    select count(*)
    into _call_count
    from deribit.matching_engine_request_call_log
    where call_timestamp > clock_timestamp() - interval '1 second';

    -- If the count exceeds the limit then wait for the remainder of the second
    if _call_count > _rate_per_second then
        _delay := 1 / _rate_per_second::float;
        _has_delay := 1;
        perform pg_sleep(_delay);
    end if;

    update deribit.internal_endpoint_rate_limit
    set last_call = clock_timestamp(),
        total_call_count = total_call_count + 1,
        total_calls_rate_limited_count = total_calls_rate_limited_count + _has_delay,
        total_rate_limiting_waiting = total_rate_limiting_waiting + make_interval(secs => _delay * _has_delay)
    where key = url;

    delete from deribit.matching_engine_request_call_log where call_timestamp < clock_timestamp() - _cleanup;

    return;
end;
$$;
