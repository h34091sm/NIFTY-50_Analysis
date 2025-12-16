import pandas as pd

# df = pd.read_csv("../sector_performance_tables/SECTOR_AVG_ROR.csv")#
df = pd.read_csv("../individual_stock_performance_tables/ALL_STOCKS_AND_DATES_cleaned.csv")
sector_avg_ror = df.groupby(["Industry", "Stock_Date"])["Rate_Of_Return"].mean().reset_index(name="Sector_Avg_ROR")

# Monthly Volatility
sector_avg_ror["Stock_Date"] = pd.to_datetime(sector_avg_ror['Stock_Date'])
sector_avg_ror["Month"] = sector_avg_ror["Stock_Date"].dt.to_period("M")
monthly_vol = sector_avg_ror.groupby(["Industry", "Month"])["Sector_Avg_ROR"].std().reset_index(name="Monthly Volatility")

# Yearly Volatility
sector_avg_ror["Year"] = sector_avg_ror["Stock_Date"].dt.to_period("Y")
yearly_vol = sector_avg_ror.groupby(["Industry", "Year"])["Sector_Avg_ROR"].std().reset_index(name="Monthly Volatility")

# Create new CSV files for Volatility
monthly_vol.to_csv("../sector_performance_tables/SECTOR_MONTHLY_VOLATILITY.csv", index=False)
yearly_vol.to_csv("../sector_performance_tables/SECTOR_YEARLY_VOLATILITY.csv", index=False)