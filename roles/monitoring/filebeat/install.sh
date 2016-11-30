
cp roles/monitoring/filebeat/config/elastic-beats.repo /etc/yum.repos.d/elastic-beats.repo

rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

yum -y install filebeat
