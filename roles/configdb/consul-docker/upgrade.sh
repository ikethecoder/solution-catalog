
docker rm -f consul

docker build --tag consul roles/configdb/consul-docker/config

(export HOST_IP=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address` && docker create --name consul --net=host -v /var/local/consul/data/consul.d:/consul/data -v /var/local/consul/ssl:/etc/consul.d/ssl -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' consul agent -bind=$HOST_IP -dns-port=53 -recursor=8.8.8.8 -retry-join=$HOST_IP -client=$HOST_IP -bootstrap-expect=1 -server -ui)
