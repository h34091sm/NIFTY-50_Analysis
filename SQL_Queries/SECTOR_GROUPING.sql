USE NIFTY_50;

SELECT * FROM all_stocks_and_dates;
SELECT * FROM stock_metadata;

SELECT	asd.Stock_Date, asd.Symbol, sm.Industry, asd.Prev_Close, asd.Open_Price, asd.High, asd.Low, asd.Last_Price, asd.Close_Price, asd.VWAP, asd.Volume, asd.Turnover, asd.Trades, asd.Deliverable_Vol, asd.Deliverable_Percent, asd.RateOfReturn
FROM 	all_stocks_and_dates asd INNER JOIN stock_metadata sm on asd.Symbol = sm.Symbol;
