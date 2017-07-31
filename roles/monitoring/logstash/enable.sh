
# Version 5.5 on CentOS does not support configtest
# sudo service logstash configtest

sudo chkconfig logstash on

sudo systemctl restart logstash
