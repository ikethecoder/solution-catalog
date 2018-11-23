

docker create --name kibana --net=vlan0 -p 5601:5601 -e ELASTICSEARCH_URL=http://elasticsearch:9200 docker.elastic.co/kibana/kibana:6.3.2
