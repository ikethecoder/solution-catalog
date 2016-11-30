


# MOVE OVER THE CERTIFICATE TO EACH CLIENT SERVER
ruby init/registry-key-value.rb certs/logstash | base64 --decode > /etc/pki/tls/certs/logstash-forwarder.crt


ruby init/template.rb roles/monitoring/filebeat/config/filebeat.yml /etc/filebeat/filebeat.yml

