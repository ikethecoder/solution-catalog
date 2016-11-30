

nohup phantomjs --webdriver=8001 >myprogram.out 2>&1 &

nohup phantomjs --local-storage-path=/tmp/phantom-storage --cookies-file=/tmp/phantomjs-cookies --webdriver=8001 >myprogram.out 2>&1 &
