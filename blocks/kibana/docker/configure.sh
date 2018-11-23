

docker create --name kibana --net=vlan0 -p 5601:5601 -e ELASTICSEARCH_URL docker.elastic.co/kibana/kibana:6.3.2
