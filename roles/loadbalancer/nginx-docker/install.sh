

docker create --name nginx -v /var/local/nginx/conf.d:/etc/nginx/conf.d:ro -v /var/local/nginx/default.conf:/etc/nginx/nginx.conf:ro -v /var/local/consul/ssl:/etc/consul.d/ssl -v /var/local/letsencrypt:/etc/letsencrypt --net=host -p 80:80 nginx


