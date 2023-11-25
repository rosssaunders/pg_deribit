# pg_deribit - Deribit API Wrapper for PostgreSQL

This project provides a PostgreSQL wrapper for the Deribit API, enabling easy interaction with Deribit's cryptocurrency trading platform through SQL queries. It's designed for developers and data analysts who want to integrate Deribit's features into PostgreSQL-based applications or perform complex data analysis.

## Features

- **Seamless Integration**: Directly use SQL to interact with Deribit's API.
- **Data Analysis**: Perform complex queries on trading data.
- **Real-Time Data**: Access live market data.
- **User-Friendly**: Designed with simplicity in mind for both developers and analysts.

## Getting Started

### Prerequisites

- Omnigres
- A Deribit account with API access

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/rosssaunders/pg_deribit.git

\echo Use "CREATE EXTENSION pg_deribit" to load this file. \quit

## Configuration
Set up your Deribit API credentials in a configuration file.
Configure your PostgreSQL connection settings.

## Usage

Connecting to Deribit API:
SELECT connect_to_deribit('your_api_key', 'your_api_secret');

Fetching Market Data:
SELECT * FROM get_market_data('BTC-25DEC20', 'options');

Placing an Order:
SELECT place_order('BTC-25DEC20', 'buy', 1, 10000);

## Documentation
Refer to the docs folder for detailed documentation on all available functions, parameters, and examples.

## Contributing
Contributions are welcome! Please read our contributing guidelines in CONTRIBUTING.md before submitting pull requests.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
Thanks to Deribit for providing the API.
Contributors and maintainers of this project.
