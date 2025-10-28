# pg_deribit Documentation

## Installing

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

See the examples in the `examples` folder for practical usage patterns.

## Omnigres Integration

pg_deribit leverages Omnigres extensions to provide powerful PostgreSQL-native API integration. Learn how we can benefit from additional Omnigres features:

- **[Executive Summary](OMNIGRES_ANALYSIS_SUMMARY.md)** - High-level overview and key findings
- **[Quick Reference](OMNIGRES_RECOMMENDATIONS.md)** - TL;DR with quick wins and priority tables
- **[Full Analysis](OMNIGRES_FEATURES.md)** - Comprehensive evaluation of all Omnigres features (15+ pages)
- **[Integration Examples](examples/omnigres_integration_examples.sql)** - Working code showing how to use new features

### Key Opportunities

The analysis identified several high-priority Omnigres features that could benefit pg_deribit:

1. **omni_var** - Better session variable management
2. **omni_session** - Enhanced authentication handling
3. **omni_json** - JSON validation and processing
4. **omni_txn** - Transaction management helpers
5. **omni_test** - Modern testing framework

See the documentation above for detailed implementation guidance.
