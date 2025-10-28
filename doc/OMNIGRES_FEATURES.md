# Omnigres Features Analysis for pg_deribit

## Executive Summary

This document analyzes Omnigres features and provides recommendations for which ones pg_deribit can benefit from. Omnigres is rapidly evolving with new features that can significantly enhance pg_deribit's capabilities in areas such as transaction management, session handling, testing, and data processing.

## Current Usage

pg_deribit currently leverages the following Omnigres extensions:

- **omni_http**: HTTP types library for common HTTP types
- **omni_httpc**: HTTP client for making API calls to Deribit

These are used throughout the codebase for JSON-RPC API communication.

## Recommended Features

### High Priority - Immediate Benefits

#### 1. omni_txn - Transaction Management
**Current Challenge**: Manual transaction handling in private API calls  
**Benefit**: Enhanced transaction control, better error handling, transaction lifecycle management

**Use Cases**:
- Wrapping multiple Deribit API calls in atomic transactions
- Better rollback handling for failed order sequences
- Transaction state management for complex trading operations

**Impact**: High - Improves reliability of multi-step operations

**Example Integration**:
```sql
-- Instead of manual BEGIN/COMMIT, use omni_txn for better control
select omni_txn.start();
select deribit.private_buy(...);
select deribit.private_sell(...);
select omni_txn.commit();
```

---

#### 2. omni_var - Variable Management  
**Current Challenge**: Using PostgreSQL session variables with `set` and `current_setting()`  
**Benefit**: More robust variable management, type safety, scoping

**Use Cases**:
- Replace `deribit.client_id`, `deribit.client_secret` session variables
- Better scoping for access tokens and refresh tokens
- Type-safe variable storage

**Impact**: Medium-High - Cleaner code, fewer bugs from string-based configuration

**Current Implementation** (sql/functions/auth.sql):
```sql
execute format('set deribit.client_id = ''%s''', client_id);
```

**Improved with omni_var**:
```sql
select omni_var.set('deribit.client_id', client_id);
```

---

#### 3. omni_session - Session Management
**Current Challenge**: Manual session variable management for authentication  
**Benefit**: Built-in session lifecycle, better token management, session persistence

**Use Cases**:
- Enhanced authentication token storage
- Session expiry management
- Multi-user session handling
- Secure credential storage

**Impact**: High - Critical for authentication improvements

**Potential Benefits**:
- Automatic session cleanup
- Session-based rate limiting per user
- Better security for stored credentials

---

#### 4. omni_json - JSON Toolkit
**Current Challenge**: Using standard PostgreSQL JSON functions  
**Benefit**: Enhanced JSON manipulation, validation, transformation capabilities

**Use Cases**:
- Validate Deribit API responses against schemas
- Advanced JSON transformations for response processing
- JSON path queries for complex response parsing
- Better handling of nested JSON in orderbook data

**Impact**: Medium - Improves data processing reliability

**Current Usage** (sql/functions/private_jsonrpc_request.sql):
```sql
_request_payload := json_build_object(
    'method', url::text,
    'jsonrpc', '2.0',
    'params', jsonb_strip_nulls(to_jsonb(request)),
    'id', _id
);
```

**Enhancement Opportunity**: Add response validation, schema checking

---

#### 5. omni_test - Testing Framework
**Current Challenge**: Using pgTAP for testing  
**Benefit**: Modern testing framework with better tooling, potentially better integration

**Use Cases**:
- Replace or complement existing pgTAP tests
- Better test organization and fixtures
- Enhanced test reporting

**Impact**: Medium - If it offers significant advantages over pgTAP

**Note**: Needs evaluation to determine if migration from pgTAP is worthwhile

---

### Medium Priority - Enhanced Features

#### 6. omni_sql - Programmatic SQL Manipulation
**Current Challenge**: Code generation in Python for SQL endpoints  
**Benefit**: Generate SQL within PostgreSQL, dynamic query building

**Use Cases**:
- Move parts of codegen logic from Python to SQL
- Dynamic query generation for flexible API calls
- SQL template management
- Runtime query optimization

**Impact**: Medium - Could simplify code generation pipeline

**Current**: Python codegen in `codegen/` directory generates 200+ endpoint files  
**Future**: Could potentially generate some endpoints dynamically

---

#### 7. omni_types - Advanced Typing Techniques
**Current Challenge**: Limited error handling types  
**Benefit**: Sum types, result types, better error modeling

**Use Cases**:
- Replace error handling with Result/Either types
- Better API response modeling
- Type-safe endpoint parameters

**Impact**: Medium - Improves type safety and error handling

**Example**:
```sql
-- Current error handling
if _http_response.status < 200 or _http_response.status >= 300 then
    raise exception ...

-- With sum types, could return Result<Response, Error>
return case 
    when success then omni_types.ok(response)
    else omni_types.err(error)
end;
```

---

#### 8. omni_id - Identity Types
**Current Challenge**: Using sequence for JSON-RPC IDs  
**Benefit**: Better ID generation (UUIDs, ULIDs, etc.)

**Use Cases**:
- Replace `internal_jsonrpc_identifier` sequence
- Generate unique request IDs
- Better traceability across distributed systems

**Impact**: Low-Medium - Marginal improvement over sequences

**Current** (sql/sequences/sequences.sql):
```sql
create sequence deribit.internal_jsonrpc_identifier;
```

**Enhancement**: Use ULID or UUID for better distribution and uniqueness

---

#### 9. omni_cloudevents - CloudEvents Support
**Current Challenge**: No event-driven architecture  
**Benefit**: Standardized event format for webhooks and notifications

**Use Cases**:
- Publish Deribit events (trades, orders, deposits) as CloudEvents
- Integration with event streaming systems
- Better observability and auditing
- Webhook delivery to external systems

**Impact**: Low-Medium - Enables event-driven patterns

**Future Architecture**:
- Emit CloudEvents for each API call to `internal_archive`
- Enable real-time notifications for trading events
- Integration with Apache Kafka, NATS, etc.

---

### Low Priority - Future Enhancements

#### 10. omni_vfs - Virtual File System
**Current Challenge**: No caching mechanism for API responses  
**Benefit**: Cache responses to disk, reduce API calls

**Use Cases**:
- Cache instrument data (changes infrequently)
- Cache historical data
- Reduce rate limiting pressure

**Impact**: Low - Optimization for specific use cases

---

#### 11. omni_csv - CSV Toolkit
**Current Challenge**: No built-in data export  
**Benefit**: Easy export of trading data to CSV

**Use Cases**:
- Export trade history
- Export order history
- Generate reports

**Impact**: Low - Nice-to-have feature

---

#### 12. omni_rest - REST API Provider
**Current Challenge**: pg_deribit is PostgreSQL-only interface  
**Benefit**: Auto-generate REST API from SQL functions

**Use Cases**:
- Expose Deribit data via HTTP REST API
- Build web applications on top of pg_deribit
- API gateway for non-PostgreSQL clients

**Impact**: Low-Medium - Extends reach but changes architecture

---

#### 13. omni_regex - Feature-rich Regular Expressions
**Current Challenge**: Standard PostgreSQL regex  
**Benefit**: Advanced regex features, better performance

**Use Cases**:
- Validate trading symbols and instrument names
- Parse complex API response strings
- Input validation

**Impact**: Low - Limited use cases

---

#### 14. omni_ledger - Financial Transaction Management
**Current Challenge**: Manual tracking of deposits/withdrawals  
**Benefit**: Double-entry bookkeeping, audit trail

**Use Cases**:
- Track wallet balances
- Audit trail for all transactions
- Reconciliation with Deribit balances

**Impact**: Low - Overlaps with Deribit's own ledger

**Note**: Interesting for building wallets on top of pg_deribit

---

#### 15. omni_auth - Authentication Management
**Current Challenge**: Manual API key management  
**Benefit**: Standardized auth patterns

**Use Cases**:
- Multi-user API key management
- Role-based access to endpoints
- API key rotation

**Impact**: Low - pg_deribit is currently single-user per session

---

#### 16. omni_httpd & omni_web - HTTP Server
**Current Challenge**: pg_deribit is client-only  
**Benefit**: Serve HTTP directly from PostgreSQL

**Use Cases**:
- Webhook endpoints for Deribit notifications
- Admin dashboard
- Real-time data feeds via WebSocket

**Impact**: Medium - Significant architecture change

**Future Possibility**: Build a web UI for pg_deribit

---

## Implementation Roadmap

### Phase 1: Core Improvements (1-2 weeks)
1. **Evaluate and integrate omni_var** - Replace session variable management
2. **Evaluate and integrate omni_session** - Enhance authentication handling
3. **Research omni_json** - Assess benefits for response processing

### Phase 2: Developer Experience (2-3 weeks)
4. **Evaluate omni_test** - Compare with pgTAP, potentially migrate
5. **Integrate omni_txn** - Add transaction helpers for complex operations
6. **Document omni_types** - Provide examples of sum types for errors

### Phase 3: Advanced Features (Future)
7. **Explore omni_sql** - Assess benefits for code generation
8. **Prototype omni_cloudevents** - For event-driven use cases
9. **Evaluate omni_rest** - Consider REST API layer

### Phase 4: Optimization (Future)
10. **Implement omni_vfs** - For caching strategies
11. **Add omni_csv** - For data export features
12. **Consider omni_httpd** - For webhook support

## Compatibility Considerations

- **PostgreSQL Version**: Currently targeting PostgreSQL 17 (Omnigres-17)
- **Extension Dependencies**: Carefully manage dependency tree
- **Migration Path**: Incremental adoption, maintain backward compatibility
- **Testing**: Ensure all existing tests pass after each integration

## Risks and Mitigation

1. **Dependency Bloat**: Only add extensions with clear, measurable benefits
2. **Breaking Changes**: Test thoroughly, use feature flags if needed
3. **Performance**: Benchmark before/after integration
4. **Maintenance**: Consider Omnigres release cycle and stability

## Success Metrics

- Reduced code complexity (fewer lines for same functionality)
- Improved error handling (fewer unhandled edge cases)
- Better test coverage
- Enhanced developer experience
- Performance improvements (where applicable)

## Conclusion

Omnigres offers numerous features that can benefit pg_deribit. The highest priority items are:

1. **omni_var** and **omni_session** for better authentication and session management
2. **omni_json** for enhanced JSON processing
3. **omni_txn** for better transaction control
4. **omni_test** for improved testing (if advantages over pgTAP are clear)

These should be evaluated and integrated first, with other features considered based on specific use cases as they arise.

## References

- [Omnigres GitHub](https://github.com/omnigres/omnigres)
- [Omnigres Documentation](https://docs.omnigres.org)
- [pg_deribit Repository](https://github.com/rosssaunders/pg_deribit)
