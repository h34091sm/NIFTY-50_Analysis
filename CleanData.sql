USE nifty_50;
CREATE TABLE IF NOT EXISTS all_stocks_and_dates (
 Stock_Date datetime,
 Symbol text,
 Prev_Close double,
 Open_Price double,
 High double,
 Low double,
 Last_Price double,
 Close_Price double,
 VWAP double,
 Volume int,
 Turnover bigint,
 Trades int,
 Deliverable_Vol int,
 Deliverable_Percent double
);

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/ALL_STOCKS_AND_DATES.csv' INTO TABLE all_stocks_and_dates
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

WITH Extract_Stock_Dates AS
(
	SELECT		*, ROW_NUMBER() OVER(PARTITION BY Symbol, Stock_Date) AS RN
    FROM		all_stocks_and_dates
    ORDER BY 	Symbol, Stock_Date
)
SELECT 'Stock_Date', 'Symbol', 'Prev_Close', 'Open_Price', 'High', 'Low', 'Last_Price', 'Close_Price', 'VWAP', 'Volume', 'Turnover', 'Trades', 'Deliverable_Vol', 'Deliverable_Percent' 
UNION ALL
SELECT	Stock_Date, Symbol, Prev_Close, Open_Price, High, Low, Last_Price, Close_Price, VWAP, Volume, Turnover, Trades, Deliverable_Vol, Deliverable_Percent
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/ALL_STOCKS_AND_DATES_cleaned.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM Extract_Stock_Dates
WHERE 	RN=1;


DROP TABLE all_stocks_and_dates;
