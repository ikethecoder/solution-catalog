cp prod-1/Files/etc/yum.repos.d/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo

sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

yum install -y elasticsearch

yum -y install epel-release

yum install -y elasticdump
