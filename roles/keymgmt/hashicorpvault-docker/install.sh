
docker build --tag vault roles/keymgmt/hashicorpvault-docker

(export HOST_IP=10.136.23.135 && docker run -d --dns=$HOST_IP --net=host --name $SERVICE -p 8200 -v /var/local/consul/ssl:/etc/consul.d/ssl --cap-add=IPC_LOCK vault server)
