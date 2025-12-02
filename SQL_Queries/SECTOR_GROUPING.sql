USE NIFTY_50;

SELECT		asd.Stock_Date, sm.Industry, avg(asd.RateOfReturn) as Avg_Daily_ROR
FROM		all_stocks_and_dates asd INNER JOIN stock_metadata sm on asd.Symbol = sm.Symbol
GROUP BY 	Industry, Stock_Date
ORDER BY	Industry;
