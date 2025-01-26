# Installing

```sql
create extension if not exists pg_deribit cascade;
```

## How to login for the current session

```sql
select deribit.set_client_auth('<CLIENT_ID>', '<CLIENT_SECRET>');
```

## Switch between the Production and TestNet servers

```sql
select deribit.enable_test_net();
select deribit.disable_test_net();
```

## Examples

Then see the examples in the `examples` folder.
