#!/bin/bash -e

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/openresty-proxy/config/nginx.conf.tpl","target":"/var/local/consul_openresty/nginx.conf","instanceId":"{{HOSTNAME}}","solution":"consul"}'

canzea --lifecycle=wire \
  --solution=ecosystem \
  --action=config \
  --args='{"source":"{{CATALOG_LOCATION}}/blocks/consul/openresty-proxy/config/mime.types","target":"/var/local/consul_openresty/mime.types","instanceId":"{{HOSTNAME}}","solution":"consul"}'

docker create --net=vlan0 --name consul_openresty \
  -v /var/local/consul_openresty:/conf \
  openresty -c /conf/nginx.conf
