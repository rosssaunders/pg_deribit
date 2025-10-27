FROM ghcr.io/omnigres/omnigres-17:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    postgresql-server-dev-all \
    postgresql-17-pgtap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    || { echo "APT-GET INSTALL FAILED"; exit 1; }

# Install pg_deribit
COPY . /usr/src/extension
WORKDIR /usr/src/extension
RUN make PG_CONFIG=/usr/lib/postgresql/17/bin/pg_config && make install PG_CONFIG=/usr/lib/postgresql/17/bin/pg_config
