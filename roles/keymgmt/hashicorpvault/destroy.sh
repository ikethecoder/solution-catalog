
curl --cacert /etc/consul.d/ssl/ca.cert --cert /etc/consul.d/ssl/consul.cert --key /etc/consul.d/ssl/consul.key -X DELETE https://consul.service.dc1.consul:8080/v1/kv/vault?recurse

systemctl restart vault
