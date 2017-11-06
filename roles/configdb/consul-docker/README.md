mkdir -p /var/local/consul

chown centos:users /var/local/consul
docker build --tag consul ./config

docker create --name consul --net=host -v /var/local/consul/data:/consul/data -v /var/local/consul/ssl:/etc/consul.d/ssl -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' $SERVICE agent -bind=$HOST_IP -dns-port=53 -recursor=8.8.8.8 -retry-join=$HOST_IP -client=$HOST_IP -bootstrap-expect=2 -server
