Due to my passions in the stock market and Data Analysis, I decided to undertake this project, which involved analysing the performance of the NIFTY-50. Undertaking it was a wonderful opportunity for me to combine and showcase my avid interest in PowerBI, SQL and Python. I even learned some basic bash scripting along the way, despite not planning to do so!

The initial dataset was a list of spreadsheets each containing a specific stock and its daily data over 21 years, such as opening and closing price, trading volume, turnover etc. My first task involved gathering all the stock data and combining it into one file to make it easier for later analysis and calculations. I then used Python and SQL to make new metrics and tables from the combined file, such as grouping the stocks by industry, calculating rate of return and yearly and monthly volatility. Once all the necessary metrics were calculated, I made a PowerBI dashboard and report to discuss my findings. 
My end result was a report containing the overview of my NIFTY-50 analysis and a ETL pipeline to transform raw data into a much more useful form. 

Throughout the process of building the ETL pipeline and analysing data, I encountered many roadblocks. For example, I noticed that at one point each entry in my dataset was being duplicated. Another instance involved me noticing that many files of the original dataset were regarding the same stock, but multiple stocks had been renamed over the 21 years. However, rather than ignoring these issues, I took my time to fix them and ensure the data I work with is as highly accurate as possible. 

The files of the ETL pipeline, in order of when they operate, are as follows: 
* data_clean_and_prep_scripts/load_and_extract.py - gathers the original stock file for each company and combines them 
* data_clean_and_prep_scripts/Clean_Data.sql - drops unnecessary columns from dataset, combines stocks of same entity which have been renamed and removes duplicate rows etc. 
* individual_stock_scripts/individual_stock_metrics.py - calculates rate of return, monthlly and yearly volatility for individual stocks.
* sector_scripts/sector_stock_metrics.py - calculates rate of return and volatility by sector
* individual_stock_scripts/STOCK_GROWTH.sql - calculates growth metrics for each stock in terms of turnover and stock value (closing price)
* sector_scripts/SECTOR_GROWTH.sql - calculates growth metrics for each sector in terms of turnover and average value
* inf_bug_fix/Remove_Inf_Values.sql - removes infinite values from dataset so that it can be loaded into PowerBI error-free

The other contents of my project are as follows: 
* NIFTY-50_Data - folder containing the raw data for each stock
* individual_stock_performance_tables - folder containing the table with all stocks combined, along with csv files for stock growth and volatility
* sector_performance_tables - folder containg csv files for sector (industry) growth and volatility
* NIFTY-50_dashboard.pbix - PowerBI file to generate final report
* NIFTY-50_Report.pdf - pdf report containing my findings and insights from project

Due to the many SQL and Python files involved in running the ETL pipeline, I created 2 bash scripts: 
* delete_csv_files.sh - remove any existing csv files for a 'fresh start' so that the ETL pipeline can recreate the files. Prevents file duplication errors in Python and SQL
* run_data_pipeline.sh - run the entire ETL pipeline

Overall, this was my first project involving thorough Data Analysis of a large dataset, and it was a positive experience! Although the project did take longer than anticipated due to some of the roadblocks I faced, it gave me practical experience of using Data Analysis skills together and certainly enhanced my knowledge within the field. I look forward engaging in more projects in Data Analysis and grow my passion within the field further in the future!
