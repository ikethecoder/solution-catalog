

# MOVE OVER THE CERTIFICATE TO EACH CLIENT SERVER
canzea --raw --util=get-key-value certs/logstash | base64 --decode > /etc/pki/tls/certs/logstash-forwarder.crt

canzea --config_git_commit --template=roles/monitoring/filebeat/config/filebeat.yml /etc/filebeat/filebeat.yml

