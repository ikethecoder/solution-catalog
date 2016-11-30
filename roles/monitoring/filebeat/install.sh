# yes | rm -rf Configuration

# git clone $GITLAB_URL/root/Configuration.git


#####################################################
# ELK Client (Filebeat)
#####################################################

cp prod-1/Files/etc/yum.repos.d/elastic-beats.repo /etc/yum.repos.d/elastic-beats.repo

sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

sudo yum -y install filebeat


# MOVE OVER THE CERTIFICATE TO EACH CLIENT SERVER
ruby init/registry-key-value.rb certs/logstash | base64 --decode > /etc/pki/tls/certs/logstash-forwarder.crt

