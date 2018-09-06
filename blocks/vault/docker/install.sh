
docker build --tag vault blocks/vault/docker

(export HOST_IP=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address` && docker create --dns=$HOST_IP --net=host --name vault -p 8200 -v /var/local/consul/ssl:/etc/consul.d/ssl --cap-add=IPC_LOCK vault server)

(export HOST_IP=`curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address` && echo "$HOST_IP vault.service.dc1.consul" >> /etc/hosts )
