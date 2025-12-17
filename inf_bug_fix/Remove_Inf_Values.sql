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

UPDATE	all_stocks_and_dates_cleaned
SET 	Rate_Of_Return = 0
WHERE 	Company LIKE 'Bharti%' AND Stock_Date = '2002-02-18';

SELECT * FROM all_stocks_and_dates_cleaned
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/individual_stock_performance_tables/ALL_STOCKS_AND_DATES_final.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

DROP TABLE IF EXISTS all_stocks_and_dates_cleaned;