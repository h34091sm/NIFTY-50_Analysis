USE NIFTY_50;

# Join tables to see industry of each company, allowing sector based metrics calculations later
(SELECT 'Stock_Date', 'Industry', 'Avg_Daily_ROR'
UNION ALL
(SELECT		asd.Stock_Date, sm.Industry, avg(asd.Rate_Of_Return) as Avg_Daily_ROR
FROM		all_stocks_and_dates_cleaned asd INNER JOIN stock_metadata sm on asd.Symbol = sm.Symbol
GROUP BY 	Industry, Stock_Date
ORDER BY	Industry))
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/sector_performance_tables/SECTOR_AVG_ROR.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'

