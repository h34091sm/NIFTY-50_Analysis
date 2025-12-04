USE nifty_50;

DROP TABLE IF EXISTS all_stocks_and_dates_cleaned;
DROP TABLE IF EXISTS stock_metadata;

CREATE TABLE all_stocks_and_dates_cleaned (
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
 Deliverable_Percent double,
 Rate_Of_Return double
);

# Extract cleaned stocks and dates data
SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/ALL_STOCKS_AND_DATES_cleaned.csv' INTO TABLE all_stocks_and_dates_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

CREATE TABLE stock_metadata (
 Company_Name text,
 Industry text,
 Symbol text,
 Series text,
 ISIN_Code text
);

# Extract stock metadata to get sector based information 
LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/NIFTY-50_Data/stock_metadata.csv' INTO TABLE stock_metadata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

