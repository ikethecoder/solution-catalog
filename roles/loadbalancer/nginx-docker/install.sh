

docker create --name nginx -v /var/local/consul/ssl:/etc/consul.d/ssl -v /var/local/letsencrypt:/etc/letsencrypt --net=host -p 80:80 nginx


