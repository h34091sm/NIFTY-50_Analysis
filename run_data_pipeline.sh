"C:/Program Files/MySQL/MySQL Server 9.4/bin/mysql_config_editor.exe" set --login-path=localdb --user=root --password

cd data_clean_and_prep_scripts
python3 load_and_extract.py
"C:/Program Files/MySQL/MySQL Server 9.4/bin/mysql.exe" --login-path=localdb --local-infile=1 < CLEAN_DATA.sql
cd ..

cd individual_stock_scripts
python3 individual_stock_metrics.py
cd ..

cd data_clean_and_prep_scripts
cd ..

cd sector_scripts
python3 sector_stock_metrics.py
cd ..

cd individual_stock_scripts
"C:/Program Files/MySQL/MySQL Server 9.4/bin/mysql.exe" --login-path=localdb --local-infile=1 < STOCK_GROWTH.sql
cd .. 

cd sector_scripts
"C:/Program Files/MySQL/MySQL Server 9.4/bin/mysql.exe" --login-path=localdb --local-infile=1 < SECTOR_GROWTH.sql
cd ..
