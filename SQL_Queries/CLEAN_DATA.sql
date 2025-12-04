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

# Import uncleaned stocks and dates data
SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/ALL_STOCKS_AND_DATES.csv' INTO TABLE all_stocks_and_dates
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

# Assign Row Number to each entry to keep track of duplicate values
WITH Extract_Stock_Dates AS
(
	SELECT		*, ROW_NUMBER() OVER(PARTITION BY Symbol, Stock_Date) AS RN
    FROM		all_stocks_and_dates
    ORDER BY 	Symbol, Stock_Date
)

# Only keep first entry of each row and load to CSV file, thereby ensuring that duplicate entries are ignored
SELECT 'Stock_Date', 'Symbol', 'Prev_Close', 'Open_Price', 'High', 'Low', 'Last_Price', 'Close_Price', 'VWAP', 'Volume', 'Turnover', 'Trades', 'Deliverable_Vol', 'Deliverable_Percent' 
UNION ALL
SELECT	Stock_Date, Symbol, Prev_Close, Open_Price, High, Low, Last_Price, Close_Price, VWAP, Volume, Turnover, Trades, Deliverable_Vol, Deliverable_Percent
FROM Extract_Stock_Dates
WHERE 	RN=1
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/ALL_STOCKS_AND_DATES_cleaned.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

DROP TABLE IF EXISTS all_stocks_and_dates;
