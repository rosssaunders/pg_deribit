# pg_deribit - Deribit API Wrapper for PostgreSQL

This project provides a PostgreSQL wrapper for the Deribit API, enabling easy interaction with Deribit's cryptocurrency trading platform from PostgreSQL. 

It's designed for developers and data analysts who want to integrate Deribit's features into PostgreSQL-based applications or perform complex data analysis.

![Who is this for](whoisthisfor.png)

## Features

- **Seamless Integration**: Directly use SQL to interact with Deribit's API.
- **Data Analysis**: Perform complex queries on trading data.
- **Real-Time Data**: Access live market data.
- **User-Friendly**: Designed with simplicity in mind for both developers and analysts.

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/)
- [Deribit account](https://www.deribit.com/) (Production or Testnet)
- [psql](https://www.postgresql.org/docs/current/app-psql.html)

### Installation

pg_deribit currently ships as source code. 

1. Clone the repository:

   ```bash
   git clone https://github.com/rosssaunders/pg_deribit
   ```

## Quickstart

Run the following commands to start a fresh container changing the port number as needed.

```bash
docker build . -t pg_deribit

# stop existing container called pg_deribit
docker stop pg_deribit

# remove any existing container called pg_deribit
docker rm -f pg_deribit

# launch the new one
docker run -d --name pg_deribit -p 5433:5432 pg_deribit

# connect to the container
psql -h localhost -p 5433 -U postgres -d deribit

# load the extension
create extension pg_deribit cascade;

# exit the container
\q
```

## Usage

See the examples in the doc folder.

## Documentation

Refer to the docs folder for examples and the sql/endpoints folder for the full list of endpoints.

## Contributing

Contributions are welcome! Please read our contributing guidelines in CONTRIBUTING.md before submitting pull requests.
