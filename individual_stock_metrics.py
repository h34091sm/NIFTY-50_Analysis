import pandas as pd

df = pd.read_csv("ALL_STOCKS_AND_DATES.csv")

# Calculate Rate of Return
ror = ((df['Close'] - df['Prev Close']) / df['Prev Close']) * 100
df['Rate of Return'] = ror
df.to_csv("ALL_STOCKS_AND_DATES.csv", index=False)

# Monthly Volatility
df["Date"] = pd.to_datetime(df["Date"])
df["Month"] = df["Date"].dt.to_period("M")
monthly_vol = df.groupby(["Symbol", "Month"])["Rate of Return"].std().reset_index(name="Monthly Volatility")

# Yearly Volatility
df["Year"] = df["Date"].dt.to_period("Y")
yearly_vol = df.groupby(["Symbol", "Year"])["Rate of Return"].std().reset_index(name="Yearly Volatility")

# Create new CSV files for Volatility
monthly_vol.to_csv("individual_stock_performance_tables/STOCK_MONTHLY_VOLATILITY.csv", index=False)
yearly_vol.to_csv("individual_stock_performance_tables/STOCK_YEARLY_VOLATILITY.csv", index=False)

