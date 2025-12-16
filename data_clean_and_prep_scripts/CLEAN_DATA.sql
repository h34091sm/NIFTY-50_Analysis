CREATE DATABASE IF NOT EXISTS nifty_50;
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
LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/individual_stock_performance_tables/ALL_STOCKS_AND_DATES.csv' INTO TABLE all_stocks_and_dates
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


# Drop unnecessary columns 
ALTER TABLE all_stocks_and_dates
DROP COLUMN Open_Price,
DROP COLUMN High,
DROP COLUMN Low,
DROP COLUMN Last_Price,
DROP COLUMN VWAP, 
DROP COLUMN Trades;

# Extract stock metadata to get sector based information 
CREATE TABLE stock_metadata (
 Company_Name text,
 Industry text,
 Symbol text,
 Series text,
 ISIN_Code text
);

LOAD DATA LOCAL INFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/NIFTY-50_Data/stock_metadata.csv' INTO TABLE stock_metadata
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


# Combine stocks of same entity that have been renamed
CREATE OR REPLACE VIEW Stock_Company_Industry_View AS
WITH distinct_symbols as 
(
	SELECT DISTINCT(Symbol) FROM all_stocks_and_dates
)
SELECT ds.Symbol, sm.Company_Name, sm.Industry FROM distinct_symbols ds LEFT JOIN stock_metadata sm on ds.Symbol = sm.Symbol;

CREATE TABLE IF NOT EXISTS Stock_Company_Industry  # Table with Stock Symbol and corresponding comapany
(
	Symbol text,
	Company_Name text,
    Industry text
); 

INSERT INTO Stock_Company_Industry
SELECT * FROM Stock_Company_Industry_View;

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'ADANIPORTS'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'ADANIPORTS')
WHERE 	Symbol = 'MUNDRAPORT';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'AXISBANK'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'AXISBANK')
WHERE 	Symbol = 'UTIBANK';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'BAJFINANCE'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'BAJFINANCE')
WHERE 	Symbol = 'BAJAUTOFIN';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'BHARTIARTL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'BHARTIARTL')
WHERE 	Symbol = 'BHARTI';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'HEROMOTOCO'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'HEROMOTOCO')
WHERE 	Symbol = 'HEROHONDA';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'HINDALCO'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'HINDALCO')
WHERE 	Symbol = 'HINDALC0';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'HINDUNILVR'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'HINDUNILVR')
WHERE 	Symbol = 'HINDLEVER';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'INFY'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'INFY')
WHERE 	Symbol = 'INFOSYSTCH';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'JSWSTEEL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'JSWSTEEL')
WHERE 	Symbol = 'JSWSTL';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'KOTAKBANK'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'KOTAKBANK')
WHERE 	Symbol = 'KOTAKMAH';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'TATAMOTORS'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'TATAMOTORS')
WHERE 	Symbol = 'TELCO';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'TATASTEEL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'TATASTEEL')
WHERE 	Symbol = 'TISCO';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'UPL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'UPL')
WHERE 	Symbol = 'UNIPHOS';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'VEDL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'VEDL')
WHERE 	Symbol = 'SESAGOA';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'VEDL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'VEDL')
WHERE 	Symbol = 'SSLT';

UPDATE	Stock_Company_Industry 
SET 	Company_Name = (SELECT Company_Name FROM Stock_Company_Industry_View WHERE Symbol = 'ZEEL'),
		Industry = (SELECT Industry FROM Stock_Company_Industry_View WHERE Symbol = 'ZEEL')
WHERE 	Symbol = 'ZEETELE';


# Remove duplicate values through the use of row number, and include the company name and industry in overall table
CREATE OR REPLACE VIEW All_Stocks_Dates_Cleaned_View AS
WITH 
Extract_Stock_Dates AS
(
	SELECT		*, ROW_NUMBER() OVER(PARTITION BY Symbol, Stock_Date) AS RN
    FROM		all_stocks_and_dates
    ORDER BY 	Symbol, Stock_Date
), 
Cleaned_Stock_Dates AS
(
	SELECT		Stock_Date, Symbol, Prev_Close, Close_Price, Volume, Turnover, Deliverable_Percent
	FROM		Extract_Stock_Dates
	WHERE		RN=1
	ORDER BY	Symbol, Stock_Date
)
SELECT		csd.Stock_Date, sci.Company_Name, sci.Industry, Prev_Close, Close_Price, Volume, Turnover, Deliverable_Percent 
FROM		Cleaned_Stock_Dates csd INNER JOIN Stock_Company_Industry sci
ON			csd.Symbol = sci.Symbol
ORDER BY 	Company_Name, Stock_Date;

SELECT *
FROM (
    SELECT 
        'Stock_Date' AS Stock_Date,
        'Company' AS Company,
        'Industry' AS Industry,
        'Prev_Close' AS Prev_Close,
        'Close_Price' AS Close_Price,
        'Volume' AS Volume,
        'Turnover' AS Turnover,
        'Deliverable_Percent' AS Deliverable_Percent,
        0 AS sort_key
    UNION ALL
    SELECT 
        Stock_Date,
        Company_Name,
        Industry,
        Prev_Close,
        Close_Price,
        Volume,
        Turnover,
        Deliverable_Percent,
        1 AS sort_key
    FROM All_Stocks_Dates_Cleaned_View
) Unioned_Stocks_Dates
ORDER BY 
    sort_key,
    Company,
    Stock_Date
INTO OUTFILE 'C:/CodingProjects/Data_Analyst_Portfolio_Project/NIFTY-50_Analysis/individual_stock_performance_tables/ALL_STOCKS_AND_DATES_cleaned.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


DROP TABLE IF EXISTS all_stocks_and_dates;
DROP TABLE IF EXISTS all_stocks_and_dates_cleaned;
DROP VIEW IF EXISTS Stock_Company_Industry_View;
DROP TABLE IF EXISTS stock_metadata;
DROP TABLE IF EXISTS Stock_Company_Industry;
DROP VIEW IF EXISTS All_Stocks_Dates_Cleaned_View;
