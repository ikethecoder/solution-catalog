
mkdir -p /opt/cloud-profile

mkdir -p /var/local/consul
chown centos:users /var/local/consul

roles/configdb/consul-docker/tls.sh

docker build --tag consul roles/configdb/consul-docker/config

(export HOST_IP=10.136.23.135 && docker create --name consul --net=host -v /var/local/consul/data/consul.d:/consul/data -v /var/local/consul/ssl:/etc/consul.d/ssl -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' consul agent -bind=$HOST_IP -dns-port=53 -recursor=8.8.8.8 -retry-join=$HOST_IP -client=$HOST_IP -bootstrap-expect=2 -server)

