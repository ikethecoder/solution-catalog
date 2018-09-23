

docker create --name nginx -v /var/local/nginx/ssl:/etc/nginx/ssl -v /var/local/nginx/conf.d:/etc/nginx/conf.d -v /var/local/nginx/default.conf:/etc/nginx/nginx.conf -v /var/local/consul/ssl:/etc/consul.d/ssl -v /var/local/letsencrypt:/etc/letsencrypt --net=host canzea/nginx

