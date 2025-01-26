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

- Docker
- A Deribit account (Prod or Test)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/rosssaunders/pg_deribit.git

\echo Use "CREATE EXTENSION pg_deribit" to load this file. \quit

## Configuration

Configure your PostgreSQL connection settings.

## Usage

See the examples in the doc folder.

## Documentation

Refer to the docs folder for examples and the sql/endpoints folder for the full list of endpoints.

## Contributing

Contributions are welcome! Please read our contributing guidelines in CONTRIBUTING.md before submitting pull requests.

## How to generate the SQL code wrappers from the Deribit HTML documentation

```PowerShell
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
cd codegen
python main.py
```
