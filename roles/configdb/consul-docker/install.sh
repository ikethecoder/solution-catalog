

docker create --name consul -p 8780:3000 rocket.chat

docker build --tag consul roles/configdb/consul-docker/config/Dockerfile

docker create --name consul --net=host -v /root/data/consul.d:/consul/data -v /root/shared/consul.d/ssl:/etc/consul.d/ssl -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' $SERVICE agent -bind=$HOST_IP -dns-port=53 -recursor=8.8.8.8 -retry-join=$HOST_IP -client=$HOST_IP -bootstrap-expect=2 -server

