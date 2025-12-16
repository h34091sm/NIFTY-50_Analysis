USE NIFTY_50;

# Import cleaned stocks and dates data and load into table
CREATE TABLE IF NOT EXISTS all_stocks_and_dates_cleaned
(
 Stock_Date datetime,
 Company text,
 Industry text,
 Prev_Close double,
 Close_Price double,
 Volume int,
 Turnover bigint,
 Deliverable_Percent double,
 Sort_Key int, 
 Rate_Of_Return double
);


SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/individual_stock_performance_tables/ALL_STOCKS_AND_DATES_cleaned.csv' INTO TABLE all_stocks_and_dates_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

# View to get the data for the first reported and last reported date of each stock - closing price and turnover 
CREATE OR REPLACE VIEW Stock_First_Last_Entries AS
WITH FD AS  # FD short for First Date
(
	SELECT	Stock_Date, Company, Close_Price, Turnover, ROW_NUMBER() OVER(PARTITION BY Company ORDER BY Stock_Date) AS RN
	FROM	all_stocks_and_dates_cleaned
), 
LD AS	# LD short for Last Date
(
	SELECT	Stock_Date, Company, Close_Price, Turnover, ROW_NUMBER() OVER(PARTITION BY Company ORDER BY Stock_Date DESC) AS RN
	FROM	all_stocks_and_dates_cleaned
)

SELECT	FD.Company, FD.Stock_Date AS First_Date, FD.Close_Price as First_Close, FD.Turnover as First_Turnover, LD.Stock_Date AS Last_Date, LD.Close_Price as Last_Close, LD.Turnover as Last_Turnover
FROM 	FD INNER JOIN LD ON FD.Company = LD.Company
WHERE	FD.RN=1 AND LD.RN=1;

# Measure the change in stock value (close price) and turnover. Then measure the rate of change, because each stock has different total duration on NIFTY-50
WITH Stock_Performance_Change AS
(
	SELECT	Company, DATEDIFF(Last_Date, First_Date) as Total_Days, Last_Close - First_Close as Change_In_Stock_Price, Last_Turnover - First_Turnover as Change_In_Turnover
	FROM	Stock_First_Last_Entries
)

(
	SELECT 'Company', 'Num Days on Stock Market', 'Rate of Stock Price Change', 'Rate of Turnover Change' 
	UNION ALL
	SELECT	Company, Total_Days, Change_In_Stock_Price / Total_Days AS Rate_Of_Price_Change, Change_In_Turnover / Total_Days AS Rate_Of_Turnover_Change
	FROM	Stock_Performance_Change
)
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/individual_stock_performance_tables/STOCK_GROWTH.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'; 

DROP TABLE IF EXISTS all_stocks_and_dates_cleaned; 
DROP TABLE IF EXISTS stock_first_last_entries;