
mkdir -p /var/local/consul_oidc_proxy/config /var/local/consul_oidc_proxy/www

docker rm -f consul_oidc_proxy || true

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/oidc-proxy/config/nginx.conf.tpl","target":"/var/local/consul_oidc_proxy/config/nginx.conf","instanceId":"{{HOSTNAME}}","solution":"consul"}'

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/oidc-proxy/config/mime.types","target":"/var/local/consul_oidc_proxy/config/mime.types","instanceId":"{{HOSTNAME}}","solution":"consul"}'

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/oidc-proxy/www/index.html","target":"/var/local/consul_oidc_proxy/www/index.html","instanceId":"{{HOSTNAME}}","solution":"consul"}'

docker create --net=vlan0 --name consul_oidc_proxy -p 9080:80 -v /var/local/letsencrypt:/letsencrypt -v /var/local/consul/ssl:/ssl -v /var/local/consul_oidc_proxy/config:/conf -v /var/local/consul_oidc_proxy/www:/www canzea/oidc-proxy:latest -c /conf/nginx.conf

