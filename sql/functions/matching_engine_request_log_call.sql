drop function if exists deribit.matching_engine_request_log_call;
create or replace function deribit.matching_engine_request_log_call(url text, dummy bigint) -- dummy is just here for force the function to be called
returns void
language plpgsql
as
$$
declare
    _call_count int;
    _rate_per_second int = 10;
    _delay float = 0;
    _cleanup interval = interval '2 seconds';
begin
    -- Insert the current timestamp into the temporary table
    insert into deribit.matching_engine_request_call_log(call_timestamp) values (clock_timestamp());

    -- Count the number of calls in the last second
    select count(*)
    into _call_count
    from deribit.matching_engine_request_call_log
    where call_timestamp > clock_timestamp() - interval '1 second';

    -- If the count exceeds the limit, return false (or raise an exception)
    if _call_count > _rate_per_second then
        _delay := 1 / _rate_per_second::float;
        perform pg_sleep(_delay);
    end if;

    update deribit.internal_endpoint_rate_limit
    set last_call = clock_timestamp(),
        calls = calls + 1,
        calls_rate_limited = calls_rate_limited + case when _delay > 0 then 1 else 0 end,
        time_waiting = time_waiting + make_interval(secs => _delay)
    where key = url;

    delete from deribit.matching_engine_request_call_log where call_timestamp < clock_timestamp() - _cleanup;

    return;
end;
$$;