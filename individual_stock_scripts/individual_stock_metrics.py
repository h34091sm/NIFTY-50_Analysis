import pandas as pd

df = pd.read_csv("../individual_stock_performance_tables/ALL_STOCKS_AND_DATES_cleaned.csv")

# Calculate Rate of Return
ror = ((df['Close_Price'] - df['Prev_Close']) / df['Prev_Close']) * 100
df['Rate_Of_Return'] = ror
df.to_csv("../individual_stock_performance_tables/ALL_STOCKS_AND_DATES_cleaned.csv", index=False)

# Monthly Volatility
df["Stock_Date"] = pd.to_datetime(df["Stock_Date"])
df["Month"] = df["Stock_Date"].dt.to_period("M")
monthly_vol = df.groupby(["Symbol", "Month"])["Rate_Of_Return"].std().reset_index(name="Monthly Volatility")

# Yearly Volatility
df["Year"] = df["Stock_Date"].dt.to_period("Y")
yearly_vol = df.groupby(["Symbol", "Year"])["Rate_Of_Return"].std().reset_index(name="Yearly Volatility")

# Create new CSV files for Volatility
monthly_vol.to_csv("../individual_stock_performance_tables/STOCK_MONTHLY_VOLATILITY.csv", index=False)
yearly_vol.to_csv("../individual_stock_performance_tables/STOCK_YEARLY_VOLATILITY.csv", index=False)

