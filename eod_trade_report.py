import argparse
import csv
from enum import Enum
"""
This generates end-of-day trade recap reports.  It reads input from four input files and produces two output files
Author: Jamie McKee
"""

def parse_args():
    parser = argparse.ArgumentParser(description = "Generates end of day trade recap reports.")
    parser.add_argument("-i", "--instruments", required=True, help="instrument file in csv format.")
    parser.add_argument("-s", "--sod_positions", required=True, help="sod positions file in csv format.")
    parser.add_argument("-a", "--accounts", required=True, help="accounts file in csv format.")
    parser.add_argument("-t", "--trades", required=True, help="trades file in csv format.")
    parser.add_argument("-pr", "--position-report", required=True, help="Output Position Report file.")
    parser.add_argument("-pnlr", "--pnl-report", required=True, help="Output PnL Report file.")
    args = parser.parse_args()
    return args

class Fieldnames(Enum):
    INSTRUMENTS = ["InstrumentId", "DisplaySymbol", "PrimaryExchange", "HandleValue", "Currency"]
    ACCOUNTS = ["AccountId", "AccountName", "TeamName"]
    SOD_POSITIONS = ["InstrumentId", "AccountId", "Quantity", "Mark", "Value"]
    TRADES = ["AccountId", "InstrumentId", "Side", "Quantity", "Price"]

# Convert the csv files into a list of dictionaries
def convert_csv(file, fieldnames):
    data = []    
    with open(file) as f:
        reader = csv.DictReader(f, fieldnames)
        for row in reader:
            data.append(row)
    return data
   
# Process the input files 
def read_data(instruments, sod_positions, accounts, trades):
   
    instr_data = convert_csv(instruments, Fieldnames.INSTRUMENTS.value)
    sod_pos_data = convert_csv(sod_positions, Fieldnames.SOD_POSITIONS.value)
    accounts_data = convert_csv(accounts, Fieldnames.ACCOUNTS.value)
    trades_data = convert_csv(trades, Fieldnames.TRADES.value)

    return instr_data, sod_pos_data, accounts_data, trades_data

# We need to net end of day position (start of day position + any changes) 
# This function updates the start-of-day positions based on trades (buy/sell).
def agregate_positions(positions, trades):
    for trade in trades:
        account_id = trade['AccountId']
        instrument_id = trade['InstrumentId']
        trade_quantity = int(trade['Quantity']) * int(trade['Side'])
        for p in positions:
            if p['AccountId'] == account_id and p['InstrumentId'] == instrument_id:
                p['Quantity'] = int(p['Quantity']) + trade_quantity
                break

    return positions

#  outputs the final position at the end of the day.
def generate_pos_report(positions, output_file):
    with open(output_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(Fieldnames.SOD_POSITIONS.value)
        for p in positions:
            writer.writerow([p['InstrumentId'], p['AccountId'], p['Quantity'], p['Mark'], p['Value']])

# Custom sorting function
def sort_key(item):
    # item[0][0] is team_name
    # item[1] is pnl
    team_name = item[0][0]
    pnl = item[1]
    return (team_name, -pnl)  # Sort by team_name ascending, pnl descending



# calculates the PnL for each account and instrument and groups it by team.
def generate_pnl_report(instruments, accounts, positions, trades, output_file):
    team_pnl = {}

    for p in positions:
        account_id = p['AccountId']
        instrument_id = p['InstrumentId']
        quantity = int(p['Quantity'])
        mark_price = float(p['Mark'])

        # Find the instrument
        instrument = None
        for inst in instruments:
            if inst['InstrumentId'] == instrument_id:
                instrument = inst
                break  # Stop after finding the first match

        display_symbol = instrument['DisplaySymbol']

        # Find the account's team
        account = None
        for acc in accounts:
            if acc['AccountId'] == account_id:
                account = acc
                break  # Stop once we find the account

        # Now we have the account, get the team name
        if account:
            team_name = account['TeamName']
        else:
            team_name = None  # In case we don't find an account

        # filter trades for the given account and instrument
        account_instrument_trades = []
        for trade in trades:
            if trade['AccountId'] == account_id and trade['InstrumentId'] == instrument_id:
                account_instrument_trades.append(trade)
         
        # calculate the total trade PnL
        total_trade_pnl = 0.0
        for trade in account_instrument_trades:
            trade_quantity = int(trade['Quantity'])
            trade_price = float(trade['Price'])
            trade_side = int(trade['Side'])
            total_trade_pnl += trade_quantity * trade_price * trade_side
        
        gross_pnl = total_trade_pnl + quantity * mark_price

        # Group PnL by team and symbol
        if (team_name, display_symbol) not in team_pnl:
            team_pnl[(team_name, display_symbol)] = 0.0
        team_pnl[(team_name, display_symbol)] += gross_pnl

    # Write PnL report to file
    with open(output_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['TeamName', 'DisplaySymbol', 'GrossPnL'])
        # Sorting and writing rows
        for (team_name, display_symbol), pnl in sorted(team_pnl.items(), key=sort_key):
            writer.writerow([team_name, display_symbol, round(pnl, 2)])


def main():
    options = parse_args()
    instruments, positions,  accounts, trades = read_data(
                    instruments=options.instruments,
                    sod_positions=options.sod_positions,
                    accounts=options.accounts,
                    trades=options.trades
                    )
    print(instruments)
    # Update positions based on any new trades
    latest_positions = agregate_positions(positions, trades)

    # Generate reports
    generate_pos_report(latest_positions, options.position_report)
    generate_pnl_report(instruments, accounts, latest_positions, trades, options.pnl_report)

if __name__ == "__main__":
    main()