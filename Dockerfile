FROM ghcr.io/omnigres/omnigres-slim:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    postgresql-server-dev-all \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    || { echo "APT-GET INSTALL FAILED"; exit 1; }

# Install pgTAP
RUN wget -c http://api.pgxn.org/dist/pgtap/1.1.0/pgtap-1.1.0.zip
RUN unzip pgtap-*
RUN export PATH=$PATH:$PGBINDIR/bin && cd pgtap-1.1.0 && make && make install

# Install pg_deribit
COPY . /usr/src/extension
WORKDIR /usr/src/extension
RUN make && make install
