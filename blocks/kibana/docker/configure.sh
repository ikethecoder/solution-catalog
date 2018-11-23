

docker create --name kibana --net=vlan0 -p 5601:5601 -e ELASTICSEARCH_URL -e XPACK_MONITORING_ENABLED=true docker.elastic.co/kibana/kibana:6.3.2
