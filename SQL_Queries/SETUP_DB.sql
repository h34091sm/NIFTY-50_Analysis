
USE nifty_50;
CREATE TABLE all_stocks_and_dates (
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
 Turnover int,
 Trades int,
 Deliverable_Vol int,
 Deliverable_Percent double,
 RateOfReturn double
);

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE 'C:/Users/mooda/OneDrive/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/ALL_STOCKS_AND_DATES.csv' INTO TABLE all_stocks_and_dates
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

LOAD DATA LOCAL INFILE 'C:/Users/mooda/OneDrive/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/NIFTY-50_Data/stock_metadata.csv' INTO TABLE stock_metadata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;