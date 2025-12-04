import pandas as pd
import os

# Gather stock file for each company, ignoring the stock_metadata file
os.chdir("NIFTY-50_Data")
csv_files = os.listdir()
csv_files.remove("stock_metadata.csv")
combined_df = []

# Get list of columns to use for new file
first_file = csv_files[0]
columns = list(pd.read_csv(first_file).columns)
columns.remove('Series') # Remove Series column, because all stocks are of Series type EQ (Equity)

# Combine the rows for each stock file, and gather them all into one big csv
for csv in csv_files:
    combined_df.append(pd.read_csv(csv, usecols=columns))

final_combined_df = pd.concat(combined_df, axis=0, ignore_index = True)
final_combined_df.to_csv("../ALL_STOCKS_AND_DATES.csv", index=False, header=True)