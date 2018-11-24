
mkdir -p /var/local/consul_openresty

docker rm -f consul_oidc || true

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/openresty-proxy/config/nginx.conf.tpl","target":"/var/local/consul_openresty/nginx.conf","instanceId":"{{HOSTNAME}}","solution":"consul"}'

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/openresty-proxy/config/mime.types","target":"/var/local/consul_openresty/mime.types","instanceId":"{{HOSTNAME}}","solution":"consul"}'

docker create --net=vlan0 --name consul_oidc -p 9080:80 -v /var/local/consul/ssl:/ssl -v /var/local/consul_openresty:/conf canzea/oidc-proxy:latest -c /conf/nginx.conf

