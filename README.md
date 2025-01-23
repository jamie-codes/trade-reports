# EOD Trade Report Generator

## Overview
The **EOD Trade Report Generator** is a Python script that generates two end-of-day trade recap reports:

1. **Position Report**: Displays the net end-of-day (EOD) position for each account and instrument.
2. **PnL Report**: Summarizes the daily mark-to-market profit and loss (PnL) for each team, grouped by instrument.

I have written two **SQL** queries which will also perform the below:

1. **Query 1**: summarizes all trade date activity for a trade team.
2. **Query 2**: calculates the new end of day positions for every account that can be inserted into the EodPositions table.
## Author
Jamie McKee

## Date
November, 2024

---

## Features
- Generate detailed position reports showing net EOD positions.
- Create PnL reports grouped by instrument and team.
- Supports CSV input and output for easy integration with existing workflows.

---

## Installation

1. Clone or copy the repository and its contents to your Linux machine.
2. Navigate to the project directory:

   ```bash
   cd trade-reports
   ```
3. Run *create_tables.sql* followed by *populate_dummy_data.sql* to populate the data.
4. Run *query1_trading_activity_summary.sql*  or *query2_eod_positions_select.sql* to generate the relevant reports you need.
---

## Usage

Run the script from the command line by specifying the input and output file paths.

### Command Example:

```bash
python eod_trade_report.py \
  -i instruments.csv \
  -a accounts.csv \
  -s sod_positions.csv \
  -t trades.csv \
  --position-report PositionReport.csv \
  --pnl-report PnLReport.csv
```

### Arguments:
- `-i`: Path to the instruments CSV file.
- `-a`: Path to the accounts CSV file.
- `-s`: Path to the start-of-day (SOD) positions CSV file.
- `-t`: Path to the trades CSV file.
- `--position-report`: Path to save the generated Position Report.
- `--pnl-report`: Path to save the generated PnL Report.

---

## Example Input Files

### `instruments.csv`
| Instrument ID | Instrument Name |
|---------------|-----------------|
| 1             | Stock A         |
| 2             | Stock B         |

### `accounts.csv`
| Account ID | Team Name |
|------------|-----------|
| 101        | Team Alpha|
| 102        | Team Beta |

### `sod_positions.csv`
| Account ID | Instrument ID | SOD Position |
|------------|---------------|--------------|
| 101        | 1             | 50           |
| 102        | 2             | 30           |

### `trades.csv`
| Account ID | Instrument ID | Quantity |
|------------|---------------|----------|
| 101        | 1             | 20       |
| 102        | 2             | -10      |

---

## Output Files

### `PositionReport.csv`
| Account ID | Instrument ID | Net EOD Position |
|------------|---------------|------------------|
| 101        | 1             | 70               |
| 102        | 2             | 20               |

### `PnLReport.csv`
| Team Name  | Instrument Name | Daily PnL |
|------------|-----------------|-----------|
| Team Alpha | Stock A         | $1,000    |
| Team Beta  | Stock B         | -$500     |

---

## Requirements
- Python 3.6 or later


---

## Future Enhancements
- Add support for real-time trade processing.
- Provide detailed error handling for missing or malformed input files.
- Create a web-based UI for easier report generation.

---
## SQL Reports

### Overview
The script can be complemented by SQL queries that generate end-of-day information. These queries are written in T-SQL dialect and are compatible with MS-SQL 2016 or greater.

## Installation

1. Clone or copy the repository and its contents to your Linux machine.
2. Navigate to the sql project directory:

   ```bash
   cd trade-reports/SQL
   ```
3. Run *create_tables.sql* followed by *populate_dummy_data.sql* to populate the data into your MS-SQL database.
4. Run *query1_trading_activity_summary.sql*  or *query2_eod_positions_select.sql* to generate the relevant reports you need.
---

## Usage

Run the script from the command line by specifying the input and output file paths.
### Table Structures

#### `Fills`
| Column          | Type                | Description                                                        |
|-----------------|---------------------|--------------------------------------------------------------------|
| FillId          | `int` (PK)         | Unique identifier for a transaction                                |
| InstrumentId    | `int`              | Identifier for a tradeable instrument (FK to InstrumentId in Instruments) |
| AccountId       | `int`              | Identifier for an account (FK to AccountId in Accounts)            |
| TraderId        | `int`              | Identifier for a trader (FK to TraderId in Traders)                |
| Quantity        | `int`              | Quantity traded, always positive                                   |
| Side            | `varchar(1)`       | Side of a trade: “B” for buy, “S” for sell                      |
| Price           | `decimal(18,10)`   | Executed price of a transaction                                    |
| ExchangeId      | `int`              | Identifier for the exchange the transaction took place on (FK to ExchangeId in Exchanges) |
| FillTime        | `datetime2(7)`     | Timestamp of the transaction                                       |
| ExchangeFillId  | `varchar(65)`      | Exchange-assigned transaction identifier                           |

#### `Instruments`
| Column          | Type                | Description                                                        |
|-----------------|---------------------|--------------------------------------------------------------------|
| InstrumentId    | `int` (PK)         | Unique identifier for a tradeable instrument                      |
| DisplaySymbol   | `varchar(65)`      | String representation of an instrument                            |
| Currency        | `varchar(3)`       | ISO 4217 3-character currency code                                 |
| PrimaryExchange | `varchar(4)`       | ISO 10383 4-character market identifier code                      |
| HandleValue     | `decimal(18,10)`   | Currency value of 1 point price fluctuation                       |

#### `Accounts`
| Column          | Type                | Description                                                        |
|-----------------|---------------------|--------------------------------------------------------------------|
| AccountId       | `int` (PK)         | Unique identifier for an account                                  |
| AccountName     | `varchar(32)`      | Name of the account                                                |

#### `Traders`
| Column          | Type                | Description                                                        |
|-----------------|---------------------|--------------------------------------------------------------------|
| TraderId        | `int` (PK)         | Unique identifier for a trader                                    |
| Username        | `varchar(32)`      | Username                                                           |
| Team            | `varchar(32)`      | Team a trader belongs to                                           |

#### `Exchanges`
| Column          | Type                | Description                                                        |
|-----------------|---------------------|--------------------------------------------------------------------|
| ExchangeId      | `int` (PK)         | Unique identifier for an exchange                                 |
| MIC             | `varchar(4)`       | ISO 10383 assigned market identifier code                         |
| CC              | `varchar(2)`       | ISO 3166 country code                                              |
| Name            | `varchar(128)`     | Exchange name                                                      |

#### `EodPositions`
| Column          | Type                | Description                                                        |
|-----------------|---------------------|--------------------------------------------------------------------|
| TradeDate       | `date`             | Trade date of position                                             |
| InstrumentId    | `int`              | Instrument ID of position (FK to InstrumentId in Instruments)      |
| AccountId       | `int`              | Account ID of position (FK to AccountId in Accounts)               |
| Quantity        | `int`              | Quantity of position                                               |
| Mark            | `decimal(18,10)`   | Mark-to-market price of position                                   |

## Author Contact
Feel free to reach out to [Jamie McKee](mailto:jamie.mckee@live.co.uk) for any questions or suggestions.
