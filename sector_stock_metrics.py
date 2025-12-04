import pandas as pd

df = pd.read_csv("sector_performance_tables/SECTOR_AVG_ROR.csv")

# Monthly Volatility
df["Stock_Date"] = pd.to_datetime(df["Stock_Date"])
df["Month"] = df["Stock_Date"].dt.to_period("M")
monthly_vol = df.groupby(["Industry", "Month"])["Avg_Daily_ROR"].std().reset_index(name="Monthly Volatility")

# Yearly Volatility
df["Year"] = df["Stock_Date"].dt.to_period("Y")
yearly_vol = df.groupby(["Industry", "Year"])["Avg_Daily_ROR"].std().reset_index(name="Yearly Volatility")

# Create new CSV files for Volatility
monthly_vol.to_csv("sector_performance_tables/SECTOR_MONTHLY_VOLATILITY.csv", index=False)
yearly_vol.to_csv("sector_performance_tables/SECTOR_YEARLY_VOLATILITY.csv", index=False)