
cp roles/monitoring/logstash/config/conf.d/* /etc/logstash/conf.d/.

ruby ./init/template.rb roles/monitoring/logstash/config/logstash/02-filebeat-input.conf /etc/logstash/conf.d/02-filebeat-input.conf
ruby ./init/template.rb roles/monitoring/logstash/config/logstash/30-elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf

# Configure the TLS Certificate and still on CONSUL (VAULT?)
# Create a TLS certificate used by all services connecting to logstash
(export SUBJECT_ADDRESS=`/sbin/ifconfig eth1 | grep 'inet ' | awk '{ print $2}'` ; ruby ./init/template.rb roles/monitoring/logstash/config/openssl.cnf /etc/pki/tls/openssl.cnf)
(cd /etc/pki/tls; sudo openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt )

base64 /etc/pki/tls/certs/logstash-forwarder.crt > /etc/pki/tls/certs/logstash-forwarder.crt64

curl -v -X PUT -H "Content-Type: text/plain" -d @/etc/pki/tls/certs/logstash-forwarder.crt64 $CONSUL_URL/v1/kv/certs/logstash

curl $CONSUL_URL/v1/kv/certs/logstash

service logstash configtest




#####################################################
# CollectD (with LogStash configuration)
#####################################################

yes | cp prod-1/Files/etc/logstash/conf.d/03-collectd.conf /etc/logstash/conf.d/.



