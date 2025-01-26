EXTENSION = pg_deribit
EXTVERSION = $(shell grep default_version $(EXTENSION).control | \
               sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")

DATA = $(filter-out $(wildcard sql/*--*.sql),$(wildcard sql/*.sql))
DOCS = $(wildcard doc/*.md)
PG_CONFIG = pg_config
PG91 = $(shell $(PG_CONFIG) --version | egrep " 8\.| 9\.0" > /dev/null && echo no || echo yes)

ifeq ($(PG91),yes)
all: sql/$(EXTENSION)--$(EXTVERSION).sql

sql/$(EXTENSION)--$(EXTVERSION).sql: \
	$(sort $(filter-out $(wildcard sql/types/*.gen.sql),     $(wildcard sql/types/*.sql))) \
	$(sort $(filter-out $(wildcard sql/sequences/*.gen.sql), $(wildcard sql/sequences/*.sql))) \
	$(sort $(filter-out $(wildcard sql/tables/*.gen.sql),    $(wildcard sql/tables/*.sql))) \
	$(sort $(filter-out $(wildcard sql/functions/*.gen.sql), $(wildcard sql/functions/*.sql))) \
	$(sort $(filter-out $(wildcard sql/triggers/*.gen.sql),  $(wildcard sql/triggers/*.sql))) \
	$(sort $(filter-out $(wildcard sql/static/*.gen.sql),    $(wildcard sql/static/*.sql))) \
	$(sort $(wildcard sql/types/*.gen.sql)) \
	$(sort $(wildcard sql/sequences/*.gen.sql)) \
	$(sort $(wildcard sql/tables/*.gen.sql)) \
	$(sort $(wildcard sql/functions/*.gen.sql)) \
	$(sort $(wildcard sql/triggers/*.gen.sql)) \
	$(sort $(wildcard sql/static/*.gen.sql)) \
	$(sort $(wildcard sql/endpoints/*.sql))
	cat $^ > $@

DATA = $(wildcard updates/*--*.sql) sql/$(EXTENSION)--$(EXTVERSION).sql
EXTRA_CLEAN = sql/$(EXTENSION)--$(EXTVERSION).sql
endif

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)