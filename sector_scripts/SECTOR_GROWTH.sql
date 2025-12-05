CREATE OR REPLACE VIEW Industry_Value_Turnover AS
SELECT		sm.Industry, asd.Stock_Date, avg(asd.Close_Price) AS Avg_Close_Price, sum(asd.Turnover) as Total_Turnover
FROM		all_stocks_and_dates_cleaned asd INNER JOIN stock_metadata sm on asd.Symbol = sm.Symbol
GROUP BY 	Industry, Stock_Date
ORDER BY	Industry;

# View to get the data for the first reported and last reported date of each stock - closing price and turnover 
CREATE OR REPLACE VIEW Industry_First_Last_Entries AS
WITH FD AS  # FD short for First Date
(
	SELECT	Stock_Date, Industry, Avg_Close_Price, Total_Turnover, ROW_NUMBER() OVER(PARTITION BY Industry ORDER BY Stock_Date) AS RN
	FROM	Industry_Value_Turnover
), 
LD AS	# LD short for Last Date
(
	SELECT	Stock_Date, Industry, Avg_Close_Price, Total_Turnover, ROW_NUMBER() OVER(PARTITION BY Industry ORDER BY Stock_Date DESC) AS RN
	FROM	Industry_Value_Turnover
)

SELECT	FD.Industry, FD.Stock_Date AS First_Date, FD.Avg_Close_Price as First_Avg_Close, FD.Total_Turnover as First_Total_Turnover, 
		LD.Stock_Date AS Last_Date, LD.Avg_Close_Price as Last_Avg_Close, LD.Total_Turnover as Last_Total_Turnover
FROM 	FD INNER JOIN LD ON FD.Industry = LD.Industry
WHERE	FD.RN=1 AND LD.RN=1;

# Measure the change in stock value (close price) and turnover. Then measure the rate of change, because each stock has different total duration on NIFTY-50
WITH Industry_Performance_Change AS
(
	SELECT	Industry, DATEDIFF(Last_Date, First_Date) as Total_Days, Last_Avg_Close - First_Avg_Close as Change_In_Avg_Price, Last_Total_Turnover - First_Total_Turnover as Change_In_Turnover
	FROM	Industry_First_Last_Entries
)
(
	SELECT 'Industry', 'Num Days on Stock Market', 'Rate of Avg Stock Price Change', 'Rate of Total Turnover Change' 
	UNION ALL
	SELECT	Industry, Total_Days, Change_In_Avg_Price / Total_Days AS Rate_Of_Price_Change, Change_In_Turnover / Total_Days AS Rate_Of_Turnover_Change
	FROM	Industry_Performance_Change
)
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/sector_performance_tables/SECTOR_GROWTH.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'; ; 