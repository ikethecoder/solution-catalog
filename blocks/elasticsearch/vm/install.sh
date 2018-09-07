cp blocks/elasticsearch/vm/config/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo

sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

yum -y install elasticsearch

yum -y install epel-release

yum -y install elasticdump
